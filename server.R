### sorghumHM

library(shiny)

data <- read.delim("data/B73v5.genelist", header=F)
colnames(data) <- c("Gene")

### function to output html
getPage <- function(htmlfile) {
  return(includeHTML(htmlfile))
}

shinyServer(function(input, output, session) {
  # notes:
  output$introNote <- renderText("The module homomine from Package Homotools is implemented to search a B73 gene in another maize genome. The service is provided by Liu lab at Kansas State University. Contact Sanzhen Liu(liu3zhen@ksu.edu) if you have a question.")
  
  # Display error message
  output$errorMessage <- renderUI({
    gene_DB_count <- sum(data$Gene %in% input$gene)
    if (gene_DB_count>0) {
      #valid_geneid <- TRUE
      return(NULL)  # No error, return NULL
    } else if (input$gene == "Zm00001eb") {
	  return(tags$div(
	    class = "alert alert-info",
	    "Please enter a valid gene ID in the left textbox"
	  ))
	} else {
	  return(tags$div(
        class = "alert alert-danger",
        paste(input$gene, "is not in the B73v5 gene list.")
	  ))
    }
  })

  # Display running message
  jobStatus <- reactiveValues(running=FALSE) 
  output$runningMessage <- renderUI({
    if (jobStatus$running) {
      return(tags$div(
        class = "alert alert-info",
        "Report the result"
      ))
    } else {
      return(NULL)
	}
  })

  observeEvent(input$go, {
	
	jobStatus$running = TRUE

	#updateActionButton(session, "run", label = "Running")
	
	#output$waithtml <- renderUI({getPage("/home/liu3zhen/shiny/maizeHM/data/job_waiting.html")}) # waiting message

	# perform analysis
	system(paste("sh scripts/1m_B73v5_homomine.sh", input$gene, input$genome)) # run homomin
	htmlout <- paste0("output/", input$genome, "/", input$gene, "/", input$gene, ".homomine.report.html")
    
	#if (file.exists(htmlout)) {
    # output$runningMessage <- renderUI(NULL)
    #}
    #Sys.sleep(30)
 	# jobStatus$running <- FALSE
	
	# display html
	output$html <- renderUI({getPage(htmlout)})
    
	# Update running status once the analysis is complete
	#later::later({
    #  jobStatus$running <- FALSE
    #}, delay = 300)  # Adjust the delay based on the expected duration of your job

	#isolate({
	#  Sys.sleep(3)
    #  jobStatus$running <- FALSE
    #})
	
	#updateActionButton(session, "run", label = "Run")
  })

  # download table
  # output$download <- downloadHandler(
  #  filename = function() {
  #   paste0("mini_", Sys.Date(), ".tsv")
  #  },
  #  write.table(outdata, file, quote=F, row.names=F, sep="\t")
  #}
})


