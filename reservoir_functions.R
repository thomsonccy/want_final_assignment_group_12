calculate_water_level_reservoir = function(state, area, alpha){
  return((-alpha*state)/area)
}

calculate_euler_forward_reservoir = function(state, dt, area, alpha) {
  forward = state + dt * calculate_water_level_reservoir(state, area, alpha)
  return(forward)
}

calculate_heuns_reservoir = function(state, dt, area, alpha) {
  s_tilde = state + dt * calculate_water_level_reservoir(state, area, alpha)
  heuns = state + dt / 2 * (calculate_water_level_reservoir(state, area, alpha) + calculate_water_level_reservoir(s_tilde, area, alpha)) 
  return(heuns)
}

#system function
calculate_rk4_reservoir = function(state, dt, area, alpha)
{
  k1 = dt*calculate_water_level_reservoir(state, area, alpha)
  k2 = dt*calculate_water_level_reservoir(state+ k1 / 5, area, alpha) 
  k3 = dt*calculate_water_level_reservoir(state+ 3/40*k1+9/40*k2, area, alpha)
  k4 = dt*calculate_water_level_reservoir(state+3/10*k1-9/10*k2+6/5*k3, area, alpha)
  k5 = dt*calculate_water_level_reservoir(state-11/54*k1+5/2*k2-70/27*k3+35/27*k4, area, alpha)
  k6 = dt*calculate_water_level_reservoir(state+1631/55296*k1+175/512*k2+575/13824*k3+44275/110592*k4+253/4096*k5, area, alpha)
  newstate4 = state + 37/378*k1+250/621*k3+125/594*k4+512/1771*k6
  return(newstate4)
}

calculate_rk5_reservoir = function(state, dt, area, alpha)
{
  k1 = dt*calculate_water_level_reservoir(state, area, alpha)
  k2 = dt*calculate_water_level_reservoir(state+ k1 / 5, area, alpha) 
  k3 = dt*calculate_water_level_reservoir(state+ 3/40*k1+9/40*k2, area, alpha)
  k4 = dt*calculate_water_level_reservoir(state+3/10*k1-9/10*k2+6/5*k3, area, alpha)
  k5 = dt*calculate_water_level_reservoir(state-11/54*k1+5/2*k2-70/27*k3+35/27*k4, area, alpha)
  k6 = dt*calculate_water_level_reservoir(state+1631/55296*k1+175/512*k2+575/13824*k3+44275/110592*k4+253/4096*k5, area, alpha)
  newstate5 = state + 2825/27648*k1+18575/48384*k3+13525/55296*k4+277/14336*k5+1/4*k6
  return(newstate5)
}


compare_methods_reservoir = function(state, dt, area, alpha, method1, method2) {
  result_method1 = method1(state, dt, area, alpha)
  result_method2 = method2(state, dt, area, alpha)
  difference = abs(result_method1 - result_method2)
  return(difference)
}

simulate_reservoir = function(begin_time, end_time, dt_start, initial_state, area, alpha, factor, tolerance, method1, method2) {
  # Initialize variables
  time = begin_time
  result_state = c(initial_state)
  result_time = c(time)
  current_state = initial_state
  iterations = 0
  
  # Simulation loop
  while(time < end_time) {
    dt = dt_start
    while (compare_methods_reservoir(current_state, dt, area, alpha, method1, method2) > tolerance) {
      iterations = iterations + 1
      dt = dt * factor
    }
    iterations = iterations + 1
    current_state = method1(current_state, dt, area, alpha)
    result_state = c(result_state, current_state)
    time = time + dt
    result_time = c(result_time, time)
  }
  
  return(list(time = result_time, state = result_state, iterations = iterations))
}