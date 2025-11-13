#!/usr/bin/env Rscript

# Install required packages if not present
packages <- c("plotly", "jsonlite", "dplyr")
new_packages <- packages[!(packages %in% installed.packages()[,"Package"])]
if(length(new_packages)) install.packages(new_packages)

library(plotly)
library(jsonlite)
library(dplyr)

# Function to generate results visualization
generate_results_charts <- function(data_json_file = "tracking_data.json", output_dir = ".") {
  
  # Read tracking data from JSON
  if (!file.exists(data_json_file)) {
    cat("No tracking data found. Creating sample data for demonstration.\n")
    # Sample data for testing
    tracking_data <- list(
      list(sender = "Alice", question = "Do you like ice cream?", answers = list(
        list(answer = "yes", timestamp = 1699859200),
        list(answer = "yes", timestamp = 1699859300),
        list(answer = "no", timestamp = 1699859400)
      )),
      list(sender = "Bob", question = "Is pizza the best food?", answers = list(
        list(answer = "yes", timestamp = 1699859500),
        list(answer = "no", timestamp = 1699859600)
      ))
    )
  } else {
    tracking_data <- fromJSON(data_json_file)
  }
  
  if (length(tracking_data) == 0) {
    cat("No questions to visualize.\n")
    return(NULL)
  }
  
  # Process data for visualization
  questions_list <- list()
  
  for (i in seq_along(tracking_data)) {
    item <- tracking_data[[i]]
    sender <- item$sender %||% "Anonymous"
    question <- item$question %||% "Question"
    answers <- item$answers %||% list()
    
    # Count yes/no answers
    yes_count <- sum(sapply(answers, function(x) x$answer == "yes"))
    no_count <- sum(sapply(answers, function(x) x$answer == "no"))
    
    questions_list[[i]] <- data.frame(
      sender = sender,
      question = question,
      yes_count = yes_count,
      no_count = no_count,
      total = yes_count + no_count,
      stringsAsFactors = FALSE
    )
  }
  
  df_questions <- bind_rows(questions_list)
  
  # Create main summary chart (bar chart)
  if (nrow(df_questions) > 0) {
    # Prepare data for grouped bar chart
    chart_data <- df_questions %>%
      select(question, yes_count, no_count) %>%
      mutate(question = substr(question, 1, 40)) # Truncate long questions
    
    # Chart 1: Yes vs No by Question
    p1 <- plot_ly(chart_data, x = ~question, y = ~yes_count, name = 'Yes ✅',
                   type = 'bar', marker = list(color = '#34d399')) %>%
      add_trace(y = ~no_count, name = 'No ❌', marker = list(color = '#ff7675')) %>%
      layout(
        title = list(text = '📊 Answer Breakdown by Question', font = list(size = 18, color = '#ff6b9d')),
        xaxis = list(title = "Questions", tickangle = -45),
        yaxis = list(title = "Count"),
        barmode = 'group',
        plot_bgcolor = '#fffaf0',
        paper_bgcolor = '#fffaf0',
        font = list(family = "Arial, sans-serif", size = 12, color = "#333"),
        hovermode = "x unified",
        margin = list(b = 100)
      )
    
    # Chart 2: Pie chart of total responses
    total_yes <- sum(df_questions$yes_count)
    total_no <- sum(df_questions$no_count)
    
    pie_data <- data.frame(
      answer = c("Yes", "No"),
      count = c(total_yes, total_no)
    )
    
    p2 <- plot_ly(pie_data, labels = ~answer, values = ~count, type = 'pie',
                   marker = list(colors = c('#34d399', '#ff7675'))) %>%
      layout(
        title = list(text = '🎯 Overall Response Distribution', font = list(size = 18, color = '#ff6b9d')),
        plot_bgcolor = '#fffaf0',
        paper_bgcolor = '#fffaf0',
        font = list(family = "Arial, sans-serif", size = 12, color = "#333")
      )
    
    # Chart 3: Total responses per question
    p3 <- plot_ly(df_questions, x = ~reorder(question, total), y = ~total,
                   type = 'bar', marker = list(color = '#ff6b9d')) %>%
      layout(
        title = list(text = '📈 Total Responses per Question', font = list(size = 18, color = '#ff6b9d')),
        xaxis = list(title = "Questions", tickangle = -45),
        yaxis = list(title = "Total Responses"),
        plot_bgcolor = '#fffaf0',
        paper_bgcolor = '#fffaf0',
        font = list(family = "Arial, sans-serif", size = 12, color = "#333"),
        margin = list(b = 100)
      )
    
    # Save individual charts
    htmlwidgets::saveWidget(p1, file = file.path(output_dir, "chart_breakdown.html"), selfcontained = TRUE)
    htmlwidgets::saveWidget(p2, file = file.path(output_dir, "chart_pie.html"), selfcontained = TRUE)
    htmlwidgets::saveWidget(p3, file = file.path(output_dir, "chart_totals.html"), selfcontained = TRUE)
    
    cat("✅ Charts generated successfully!\n")
    cat("📁 Files created:\n")
    cat("  - chart_breakdown.html\n")
    cat("  - chart_pie.html\n")
    cat("  - chart_totals.html\n")
    
    return(list(
      questions_df = df_questions,
      summary = list(
        total_questions = nrow(df_questions),
        total_yes = total_yes,
        total_no = total_no,
        total_responses = total_yes + total_no
      )
    ))
  }
}

# Run the function
if (!interactive()) {
  result <- generate_results_charts("tracking_data.json", ".")
  if (!is.null(result)) {
    cat("\n📊 Summary Statistics:\n")
    cat("Total Questions:", result$summary$total_questions, "\n")
    cat("Total Yes Answers:", result$summary$total_yes, "\n")
    cat("Total No Answers:", result$summary$total_no, "\n")
    cat("Total Responses:", result$summary$total_responses, "\n")
  }
}
