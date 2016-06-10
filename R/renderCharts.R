renderBarChart <- function(div_id,
                           data,
                           direction = "horizontal",
                           running_in_shiny = TRUE){

  # Check if the "direction" value is valid
  if(direction == "horizontal"){
    direction_vector = c("xAxis", "yAxis")
  }else{
    if(direction == "vertical"){
      direction_vector = c("yAxis", "xAxis")
    }else{
      stop("The 'direction' argument can be either 'horizontal' or 'vertical'")
    }
  }

  names(data) <- c("name", "value")
  yaxis_name <- data$name
  data <- as.character(jsonlite::toJSON(data))
  data <- gsub("\"", "\'", data)


  part_1 <- paste("var " ,
                  div_id,
                  " = echarts.init(document.getElementById('",
                  div_id,
                  "'));",
                  sep="")

  part_2 <- paste("option_", div_id,
                  " = {tooltip : {trigger:'axis', axisPointer:{type:'shadow'}}, ",
                  "toolbox:{feature:{saveAsImage:{}}}, ",
                  direction_vector[1],
                  ":[{type:'value'}], ",
                  direction_vector[2],
                  ":[{type:'category', axisTick:{show:false}, data:[",
                  paste(sapply(yaxis_name, function(x){paste("'", x, "'", sep="")}), collapse = ","),
                  "]}],series : [{type: 'bar', ",
                  "label:{normal:{show: true, position:'inside'}},",
                  sep="")


  part_3 <- paste("data:",
                  data,
                  "}]};",
                  sep="")

  part_4 <- paste(div_id,
                  ".setOption(option_",
                  div_id,
                  ");",
                  sep="")

  to_eval <- paste("output$", div_id ," <- renderUI({fluidPage(tags$script(\"",
                   part_1, part_2, part_3, part_4,
                   "\"))})",
                 sep="")

  if(running_in_shiny == TRUE){
    eval(parse(text = to_eval), envir = parent.frame())
  } else {
    cat(to_eval)
  }
}








renderPieChart <- function(div_id,
                           data,
                           radius = "50%",
                           center_x = "50%", center_y = "50%",
                           running_in_shiny = TRUE){

  names(data) <- c("name", "value")
  legend_data <- paste(sapply(data$name, function(x){paste("'", x, "'", sep="")}), collapse=", ")
  data <- as.character(jsonlite::toJSON(data))
  data <- gsub("\"", "\'", data)

  part_1 <- paste("var " ,
                  div_id,
                  " = echarts.init(document.getElementById('",
                  div_id,
                  "'));",
                  sep="")

  part_2 <- paste("option_", div_id, " = {tooltip : {trigger: 'item',formatter: '{b} : {c} ({d}%)'}, toolbox:{feature:{saveAsImage:{}}}, ",
                  "legend:{orient: 'vertical', left: 'left', data:[",
                  legend_data,
                  "]},",
                  "series : [{type: 'pie', radius:'",
                  radius, "', center :['",
                  center_x, "','",
                  center_y, "'],",
                  sep="")

  part_3 <- paste("data:",
                  data,
                  ", itemStyle: { emphasis: { shadowBlur: 10, shadowOffsetX: 0, shadowColor: 'rgba(0, 0, 0, 0.5)'}}}]};",
                  sep="")

  part_4 <- paste(div_id,
                  ".setOption(option_",
                  div_id,
                  ");",
                  sep="")

  to_eval <- paste("output$", div_id ," <- renderUI({fluidPage(tags$script(\"",
                   part_1, part_2, part_3, part_4,
                   "\"))})",
                   sep="")

  if(running_in_shiny == TRUE){
    eval(parse(text = to_eval), envir = parent.frame())
  } else {
    cat(to_eval)
  }
}



renderLineChart <- function(div_id,
                            data,
                            running_in_shiny = TRUE){

  xaxis_name <- paste(sapply(row.names(data), function(x){paste("'", x, "'", sep="")}), collapse=", ")
  xaxis_name <- paste("[", xaxis_name, "]", sep="")
  legend_name <- paste(sapply(names(data), function(x){paste("'", x, "'", sep="")}), collapse=", ")
  legend_name <- paste("[", legend_name, "]", sep="")

  part_1 <- paste("var " ,
                  div_id,
                  " = echarts.init(document.getElementById('",
                  div_id,
                  "'));",
                  sep="")

  series_data <- rep("", dim(data)[2])
  for(i in 1:length(series_data)){
    temp <- paste("{name:'", names(data)[i], "', type:'line', data:[",
                  paste(data[, i], collapse = ", "),
                  "]}",
                  sep=""
    )
    series_data[i] <- temp
  }
  series_data <- paste(series_data, collapse = ", ")

  part_2 <- paste("option_", div_id, " = {tooltip : {trigger: 'axis'}, toolbox:{feature:{saveAsImage:{}}}, ",
                  "legend:{data:",
                  legend_name,
                  "}, yAxis: { type: 'value'},",
                  "xAxis:{type:'category', boundaryGap: false, data:",
                  xaxis_name,
                  "}, series:[",
                  series_data,
                  "]};",
                  sep="")

  part_3 <- paste(div_id,
                  ".setOption(option_",
                  div_id,
                  ");",
                  sep="")

  to_eval <- paste("output$", div_id ," <- renderUI({fluidPage(tags$script(\"",
                   part_1, part_2, part_3,
                   "\"))})",
                   sep="")

  if(running_in_shiny == TRUE){
    eval(parse(text = to_eval), envir = parent.frame())
  } else {
    cat(to_eval)
  }
}


