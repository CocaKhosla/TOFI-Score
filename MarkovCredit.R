library(markovchain)
library(matlib)

after_transition <- function(chain, years_bond){
  
  # raises the transition matrix to the power of the years in the future
  new_chain <- chain ** years_bond
  
  return(new_chain)
}

return_index <- function(bond){
  
  # returns index position of bond row in transition matrix
  
  if (identical(bond,"AAA")){
    return (1)
  }
  
  if (identical(bond,"AA")){
    return (2) 
  }
  
  if (identical(bond,"A")){
    return (3)
  }
  
  if (identical(bond,"BBB")){
    return (4)
  }  
  
  if (identical(bond,"BB")){
    return (5)
  }
  
  if (identical(bond,"B")){
    return (6)
  }
  
  if (identical(bond,"CCC/C")){
    return (7)
  }
  
  if (identical(bond,"NR")){
    return (8)
  }
  
  if (identical(bond,"default")){
    return (9)
  }
}

check_bond <- function(x, start_bond, end_bond, row_index, col_index){
  
  # prints the transition probability from one state (bond) to another
  print(paste0("Transition from ",start_bond," to ",end_bond," with probability ",x[row_index][col_index]))
  
}

proportion_bonds <- function(x,bond){
  # sum = different types of bonds
  sum <- 8
  
  num <- 0
  # finds number of selected bonds of selected bond
  for (i in 1:8){
    num <- num + x[i][bond]
  }
  return (num/sum)
}

expected_default <- function(chain, pos){
  
  # finds the Q matrix
  Q <- matrix(c(chain[1][1:8],chain[2][1:8],chain[3][1:8], chain[4][1:8], chain[5][1:8], 
                chain[6][1:8], chain[7][1:8], chain[8][1:8]), nrow=8, byrow = T)
  
  # Expected time till absorption state matrix = (I - Q)^-1
  # Absorption state here is default
  
  inverse <- inv(diag(8) - Q)
  return(sum(inverse[pos,1:8]))
}

risk_factor <- function(chain){
  
  rates <- matrix(c(0.0683, 0.0586, 0.0520, 0.0465,
                    0.0746, 0.0591, 0.0515, 0.0434,
                    0.0784, 0.0623, 0.0579, 0.0510,
                    0.0760, 0.0633, 0.0595, 0.0544,
                    0.0877, 0.0682, 0.0724, 0.0580,
                    0.0148, 0.0363, 0.0543, 0.0553,
                    0.2888, 0.0243, 0.0679, 0.0803,
                    0.0250, 0.0150, 0.0150, 0.0100 ), nrow = 8, byrow=T)
  
  # the rates are from S&P average rates that are annualized for: 
  # 1 year, 3 years, 5 years, 10 years
  #  NR rates which are taken from adidas' official website and are annualized similarly
  
  # the model uses assumptions 
  # assumption 1: when a bond defaults, you bondholder gets 0 return, i.e,
  # not even the principal amount is paid
  # assumption 2: face value of each bond is $1000 dollars
  # assumption 3: transition of a bond rated x into a different rating y results in the 
  # interest rate of the bond changing to the interest rate of y for the whole period
  
  
  # bond_value_ratex determines the value of the bond
  # when compounded for x years annually
  
  bond_value_rate1 <- matrix(c(0,0,0,0,0,0,0,0), byrow = T)
  bond_value_rate3 <- matrix(c(0,0,0,0,0,0,0,0), byrow = T)
  bond_value_rate5 <- matrix(c(0,0,0,0,0,0,0,0), byrow = T)
  bond_value_rate10 <- matrix(c(0,0,0,0,0,0,0,0), byrow = T)
  
  # the interest is calculated for all the years
  # using the compound interest formula
  
  time_period <- 1
  for (i in (1:8)){
    time_period <- 1
    bond_value_rate1[i] <- 1000 * ((1+rates[i][j])**(time_period))
        
  }
  
  for (i in (1:8)){
    time_period <- 3
    bond_value_rate3[i] <- 1000 * (1+rates[i][j])**(time_period)
  }
  
  for (i in (1:8)){
    time_period <- 5
    bond_value_rate5[i] <- 1000 * (1+rates[i][j])**(time_period)
  }
  
  for (i in (1:8)){
    time_period <- 10
    bond_value_rate10[i] <- 1000 * (1+rates[i][j])**(time_period)
  }
  
  # bond_exp_valuex stores the expected return on a bond
   
  bond_exp_value1 <- matrix(c(0,0,0,0,0,0,0,0), byrow = T)
  bond_exp_value3 <- matrix(c(0,0,0,0,0,0,0,0), byrow = T)
  bond_exp_value5 <- matrix(c(0,0,0,0,0,0,0,0), byrow = T)
  bond_exp_value10 <- matrix(c(0,0,0,0,0,0,0,0), byrow = T)
  pos <- 1
  
  # the expected return E(Return) of a bond x is calculated by multiplying the bond value after
  # it has been compounded for y years to the probability of transition
  # the summation of this results in E(Return) of bond x
  # E(Return) gives a stronger idea of our returns since it takes into account the transition 
  # of the bond into different bonds
  
  temp_chain <- chain
  for (i in (1:8)){
    for (j in (1:4)){
      
      if (j == 1){
        time_period = 1
        bond_exp_value1[i] <- sum(bond_value_rate1[x<-1:8][1] * after_transition(temp_chain,time_period)[i][x])
      }
      
      if (j == 2){
        time_period <- 3
        bond_exp_value3[i] <- sum(bond_value_rate3[x<-1:8][1] * after_transition(temp_chain,time_period)[i][x])
      }
      
      if (j == 3){
        time_period <- 5
        bond_exp_value5[i] <- sum(bond_value_rate5[x<-1:8][1] * after_transition(temp_chain,time_period)[i][x])
      }
      
      if (j == 4){
        time_period <- 10
        bond_exp_value10[i] <- sum(bond_value_rate10[x<-1:8][1] * after_transition(temp_chain,time_period)[i][x])
      }
      
      
      temp_chain <- chain
    }
  }
  
  
  years_name <- c('1', '3', '5', '10')
  bond_names <- c("AAA", "AA", "A" , "BBB", "BB", "B", "CCC/C", "NR")
  
  # TOFI stands for Tentative Opportunity For Increment
  # the tofi matrix (TOFI Score) represents the difference between bond_exp_value and bond_value_rate
  # if TOFI Score > 0, it means that expected value is greater than the value of it being compounded
  # this means that one is guaranteed to get a higher price than the rate
  # at which the bond is being offered
  # if TOFI Score < 0, it means that expected value is less than the value of it being compounded
  # this means that your net Return can be less than what is being advertised
  # this function returns all bonds with positive TOFI Scores
  
  tofi <- t(matrix(c(bond_exp_value1 - bond_value_rate1,bond_exp_value3 - bond_value_rate3,
                   bond_exp_value5 - bond_value_rate5, bond_exp_value10 - bond_value_rate10),
                 nrow = 4, byrow = T))
  
  rownames(tofi) <- bond_names
  colnames(tofi) <- years_name
  
  # print TOFI Scores
  print(tofi)
  tofi_pos <- which(tofi > 0, arr.ind = T)
  return(list("position"=tofi_pos, "tofi_score"=tofi[which(tofi>0)]))
  
}

time_calc <- function(col){
  
  # returns time for respective column
  
  if (col == 1)
    return(1)
  
  if (col == 2)
    return(3)
  
  if (col == 3)
    return(5)
  
  if (col == 4)
    return(10)
}



# all the bonds are taken from: 
# S&P 2018 Annual Global Corporate Default And Rating Transition Study
# except for the NR bonds whose probability is assumed
transition_names <- c("AAA", "AA", "A" , "BBB", "BB", "B", "CCC/C", "NR", "default")
transition_matrix <- matrix(c(0.8734, 0.0866, 0.0058, 0.0004, 0.0012, 0.0004, 0.0004, 0.0318, 0, 
                              0.0051, 0.8716, 0.0745, 0.0057, 0.0008, 0.0010, 0.0003, 0.0407, 0.0003,
                              0.0004, 0.0172, 0.8800, 0.0532, 0.0038, 0.0015, 0.0003, 0.0429, 0.0007,
                              0.0001, 0.0012, 0.0349, 0.8633, 0.0367, 0.0058, 0.0011, 0.0549, 0.0020,
                              0.0002, 0.0005, 0.0018, 0.0484, 0.7729, 0.0750, 0.0056, 0.0881, 0.0075,
                              0.0000, 0.0003, 0.0010, 0.0020, 0.0453, 0.7546, 0.0460, 0.1145, 0.0363,
                              0.0000, 0.0000, 0.0016, 0.0025, 0.0066, 0.1188, 0.4386, 0.1430, 0.2889,
                              0.0000, 0.0000, 0.0020, 0.0030, 0.0050, 0.0100, 0.2300, 0.4300, 0.3200,
                              0.0000, 0.0000, 0.0000, 0.0000, 0.0000, 0.0000, 0.0000, 0.0000, 1), nrow = 9, byrow = T, 
                            dimnames = list(transition_names,transition_names))

chain <- new("markovchain", states = transition_names, byrow = T, transitionMatrix = transition_matrix,
             name = "Credit Risk Modelling")

# user input

# years later to check matrix
years_bond <- 2

# bond we want to look at
start_bond <- "BBB"

# bond we want it transitions into
end_bond <- "AA"

# what fraction of the bonds are these
fraction <- "AAA"

# expected time for given bond to default
expected_bond <- "BBB"

# bond we get after transition
x <- after_transition(chain, years_bond)

chain
print(x)

# transition probability from start_bond to end_bond
check_bond(x, start_bond, end_bond, return_index(start_bond), return_index(end_bond))

# fraction of x rated bond is
print(paste0("Fraction of ",fraction," bonds are: ",proportion_bonds(x, return_index(fraction))))

# fraction of the bonds that default
print(paste0("Fraction of bonds that default: ",proportion_bonds(x, 9)))

# expected time for a bond to default
print(paste0("Expected time for ",expected_bond," to default: ",
             expected_default(chain, return_index(expected_bond))," years"))

# bonds which have increment opportunity
bond_location <- risk_factor(chain)

print(paste0("the TOFI bond investment(s) are (row, col): "))
print(paste0(transition_names[strtoi(bond_location$position[1])]," with time (in years): ",
             time_calc(strtoi(bond_location$position[2]))))
print(paste0("with a TOFI Score of: ",round(bond_location$tofi_score, digits = 2)))

# TOFI stands for Tentative Opportunity For Increment
# TOFI and TOFI Score is explained in the risk_factor method