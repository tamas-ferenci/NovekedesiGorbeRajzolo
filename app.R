library( shiny )
library( readxl )
library( lattice )
library( FField )
library( grid )
library( stringi )

source( "lms3_macro_calcz_woload.R" )

qs <- c( 3, 15, 50, 85, 97 )/100

lmsdat <- readRDS( "data/lmsdat.rds" )
lmsdat$lms_heightfa_boys$M[ lmsdat$lms_heightfa_boys$Months<=24 ] <-
  lmsdat$lms_heightfa_boys$M[ lmsdat$lms_heightfa_boys$Months<=24 ] - 0.7
lmsdat$lms_heightfa_girls$M[ lmsdat$lms_heightfa_girls$Months<=24 ] <-
  lmsdat$lms_heightfa_girls$M[ lmsdat$lms_heightfa_girls$Months<=24 ] - 0.7
lmsplot <- lapply( lmsdat, function( l ) {
  lplot <- data.frame( l$Months, sapply( qs, function( q ) apply( l, 1,
                                                                  function( x ) x["M"]*( 1+x["L"]*x["S"]*qnorm(q) )^( 1/x["L"] ) ) ) )
  colnames( lplot ) <- c( "Months", qs*100 )
  lplot <- reshape( lplot, varying = list( colnames( lplot )[ -1 ] ), v.names = "Measurement",
                    timevar = "Percentile", times = colnames( lplot )[ -1 ], direction = "long" )[ , 1:3 ]
  lplot$Percentile <- as.numeric( lplot$Percentile )
  return( lplot )
} )

ui <- fluidPage(
  
  tags$style( ".shiny-file-input-progress {display: none}" ),
  
  titlePanel("Növekedési görbe rajzoló"),
  
  h4( "Írta: Ferenci Tamás (Óbudai Egyetem, Élettani Szabályozások Kutatóközpont)" ),
  p( "A program használatát részletesen bemutató súgó, valamint a technikai részletek",
     a( "itt", href = "https://github.com/tamas-ferenci/NovekedesiGorbeRajzolo", target = "_blank" ),
     "olvashatóak el."),
  
  sidebarLayout(
    sidebarPanel(
      selectInput( "sex", "A gyermek neme:", c( "Fiú" = "M", "Lány" = "F" ) ),
      fileInput( "rawdata", "A növekedési adatokat tartalmazó fájl (csv, xls vagy xlsx):",
                 buttonLabel = "Tallózás", placeholder = "Még nincs kiválasztva fájl!" ),
      selectInput( "fileformat", "A fájl formátuma:", c( "A fájl az életkorokat tartalmazza" = 1,
                                                         "A fájl a mérések időpontját tartalmazza" = 2 ) ),
      conditionalPanel( "input.fileformat==2",
                        dateInput( "birthdate", "A gyermek születési dátuma:", weekstart = 1, language = "hu" ) ),
      conditionalPanel( "input.fileformat==1",
                        p( "A fájl beolvasása a 2. sortól kezdődik (feltételezzük, hogy az első a fejléc)." ),
                        p( "A fájl a következő oszlopokat kell, hogy tartalmazza:" ),
                        tags$ol( tags$li( "Életkor" ), tags$li( "Életkor mértékegysége (hét vagy hónap vagy év)" ),
                                 tags$li( "Testmagasság" ), tags$li( "Testmagasság mértékegysége (cm vagy m)" ),
                                 tags$li( "Testtömeg" ), tags$li( "Testtömeg mértékegysége (g vagy kg)" ), type = "A" ) ),
      conditionalPanel( "input.fileformat==2",
                        p( "A fájl beolvasása a 2. sortól kezdődik (feltételezzük, hogy az első a fejléc)." ),
                        p( "A fájl a következő oszlopokat kell, hogy tartalmazza:" ),
                        tags$ol( tags$li( "Mérés időpontja (csv esetében ÉÉÉÉ-HH-NN formában)" ),
                                 tags$li( "Testmagasság" ), tags$li( "Testmagasság mértékegysége (cm vagy m)" ),
                                 tags$li( "Testtömeg" ), tags$li( "Testtömeg mértékegysége (g vagy kg)" ), type = "A" ) ),
      selectInput( "target", "Ábrázolandó jellemző:", c( "Testmagasság" = "height", "Testtömeg" = "weight",
                                                         "Testtömegindex (BMI)" = "bmi" ) ),
      downloadButton( "PlotDownloadPDF", "Az ábra letöltése (PDF)" ),
      downloadButton( "PlotDownloadPNG", "Az ábra letöltése (PNG)" ),
      checkboxInput( "advanced", "Haladó beállítások megjelenítése" ),
      conditionalPanel( "input.advanced==1",
                        selectInput( "pointlabelpos", "Pontok feliratainak helye:", c( "Pont alatt" = 1, "Ponttól balra" = 2,
                                                                                       "Pont felett" = 3, "Ponttól jobbra" = 4,
                                                                                       "Optimálisan (FField)" = 5 ), selected = 3 ),
                        selectInput( "pointlabeltext", "Pontok feliratai:", c( "Percentilis"  = "P", "z-score" = "Z",
                                                                               "Percentilis (z-score)" = "PZ",
                                                                               "z-score (percentilis)" = "ZP" ) ) )
    ),
    
    mainPanel(
      plotOutput( "resultplot" )
    )
  ),
  
  tags$script( HTML( "var sc_project=11601191; 
                      var sc_invisible=1; 
                      var sc_security=\"5a06c22d\";
                      var scJsHost = ((\"https:\" == document.location.protocol) ?
                      \"https://secure.\" : \"http://www.\");
                      document.write(\"<sc\"+\"ript type='text/javascript' src='\" +
                      scJsHost+
                      \"statcounter.com/counter/counter.js'></\"+\"script>\");" ), type = "text/javascript" )
  
)

server <- function(input, output) {
  
  RawData <- reactive( { if( !is.null( input$rawdata ) ) {
    validate( need( input$rawdata$type%in%c( "application/vnd.ms-excel",
                                             "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet",
                                             "text/csv" ),
                    "A program csak csv, xls és xlsx formátumú fájlokat tud feldolgozni!" ) )
    if ( tail( strsplit( input$rawdata$name, ".", fixed = TRUE )[[ 1 ]], 1 )=="csv" ) {
      rd <- read.csv2( input$rawdata$datapath, stringsAsFactors = FALSE,
                       fileEncoding = stri_enc_detect( input$rawdata$datapath )[[ 1 ]]$Encoding[ 1 ] )
    } else {
      rd <- read_excel( input$rawdata$datapath )
    }
    if ( input$fileformat==1 ) {
      validate( need( ncol( rd )==6, "A fájl 6 oszlopot kell hogy tartalmazzon!" ) )
      colnames( rd ) <- c( "age", "ageuom", "height", "heightuom", "weight", "weightuom" )
      validate( need( is.numeric( rd$age ), "Az A oszlop csak számokat tartalmazhat!" ) )
      validate( need( sum( !unique( rd$ageuom )%in%c( "hét", "hónap", "év" ) )==0,
                      "A B oszlop csak a hét, hónap és év mértékegységek valamelyikét tartalmazhatja!" ) )
      rd <- merge( rd, data.frame( ageuom = c( "hét", "hónap", "év" ), convage = c( 1/7, 1, 12 ) ) )
      rd$agemons <- rd$age*rd$convage
      rd <- rd[ , c( "agemons", "height", "heightuom", "weight", "weightuom" ) ]
    } else {
      validate( need( ncol( rd )==5, "A fájl 5 oszlopot kell hogy tartalmazzon!" ) )
      colnames( rd ) <- c( "date", "height", "heightuom", "weight", "weightuom" )
      validate( need( !is.na( as.Date( as.character( rd$date ), format = "%Y-%m-%d" ) ),
                      "Az A oszlop dátumot kell, hogy tartalmazzon (csv esetében ÉÉÉÉ-HH-NN formátumban)!" ) )
      rd$date <- as.Date( as.character( rd$date ), format = "%Y-%m-%d" )
      validate( need( min( rd$date )>=input$birthdate, "A mérések dátumai mind későbbiek kellenek legyenek, mint a születési dátum!" ) )
      rd$agemons <- as.numeric( difftime( rd$date, input$birthdate, units = "days" )/30.5 )
      rd <- rd[ , c( "agemons", "height", "heightuom", "weight", "weightuom" ) ]
    }
    validate( need( is.numeric( rd$height ), "A testmagasság oszlop csak számokat tartalmazhat!" ),
              need( sum( !unique( rd$heightuom )%in%c( "cm", "m" ) )==0, "A testmagasság mértékegysége csak cm vagy m lehet!" ) )
    rd <- merge( rd, data.frame( heightuom = c( "cm", "m" ), convheight = c( 1, 100 ) ) )
    rd$height <- rd$height*rd$convheight
    validate( need( is.numeric( rd$weight ), "A testtömeg oszlop csak számokat tartalmazhat!" ),
              need( sum( !unique( rd$weightuom )%in%c( "g", "kg" ) )==0,
                    "A testtömeg mértékegysége csak g vagy kg lehet!" ) )
    rd <- merge( rd, data.frame( weightuom = c( "g", "kg" ), convweight = c( 1/1000, 1 ) ) )
    rd$weight <- rd$weight*rd$convweight
    rd$bmi <- rd$weight/(rd$height/100)^2
    rd$sex <- input$sex
    rd$id <- 1:nrow( rd )
    rd <- rd[ , c( "id", "agemons", "sex", "height", "weight", "bmi" ) ]
    rd <- data.frame( rd, calcZ( y = "height", data = rd, lmsdat = lmsdat )[ , c( "zscore", "percentile" ) ],
                       calcZ( y = "weight", data = rd, lmsdat = lmsdat )[ , c( "zscore", "percentile" ) ],
                       calcZ( y = "bmi", data = rd, lmsdat = lmsdat )[ , c( "zscore", "percentile" ) ] )
    rd <- rd[ order( rd$agemons ), ]
    colnames( rd )[ 7:12 ] <- c( "heightZ", "heightP", "weightZ", "weightP", "bmiZ", "bmiP" )
    return( rd )
  }
  } )
  
  plotInput <- reactive( {
    if( is.null( RawData() ) ) return()
    
    lmsplotactual <- eval( parse( text = paste0( "lmsplot$lms_", input$target, "fa_",
                                                 switch( input$sex, "M" = "boys", "F" = "girls" ) ) ) )
    
    eranx <- extendrange( range( RawData()$agemons ), f = 0.1 )
    erany <- extendrange( range( c( RawData()[[ input$target ]], lmsplotactual$Measurement[ lmsplotactual$Months < eranx[ 2 ] ] ) ),
                          f = 0.1 )
    
    p1 <- xyplot( Measurement ~ Months, groups = Percentile, data = lmsplotactual[ lmsplotactual$Months < eranx[ 2 ], ],
                  rawdata = RawData(), xlim = eranx+c( 0, 1 ), ylim = erany, type = "l", grid = TRUE, xlab = "Életkor [hónap]",
                  ylab = switch( input$target, height = "Testmagasság [cm]", weight = "Testtömeg [kg]",
                                 bmi = expression("Testtömeg-index [kg/m"^2*"]" ) ),
                  col = c( "red", "orange", "green", "orange", "red" ),
                  panel = function( rawdata, ... ) {
                    dotdotdot <- list( ... )
                    panel.xyplot( ... )
                    panel.xyplot( rawdata$agemons, rawdata[[ input$target ]], type = "b", col = "blue", lwd = 2, pch = 19 )
                    panel.text( rep( eranx[ 2 ]+0.5, 5 ), tapply( dotdotdot$y, dotdotdot$groups, max ), paste0( "P", qs*100 ),
                                col = c( "red", "orange", "green", "orange", "red" ) )
                    pointlabtext <- switch( input$pointlabeltext,
                                            "P" = rawdata[[ paste0( input$target, "P" ) ]],
                                            "Z" = rawdata[[ paste0( input$target, "Z" ) ]],
                                            "PZ" = paste0( rawdata[[ paste0( input$target, "P" ) ]], " (",
                                                           rawdata[[ paste0( input$target, "Z" ) ]], ")" ),
                                            "ZP" = paste0( rawdata[[ paste0( input$target, "Z" ) ]], " (",
                                                           rawdata[[ paste0( input$target, "P" ) ]] , ")" ) )
                    if ( input$pointlabelpos==5 ) {
                      ff <- FFieldPtRep( rawdata[, c( "agemons", input$target ) ], rep.fact = 2, attr.fact = 0.85 )
                      panel.text( ff$x, ff$y, pointlabtext, col = "blue" )
                    } else {
                      panel.text( rawdata$agemons, rawdata[[ input$target ]], pointlabtext, col = "blue", pos = input$pointlabelpos )
                    }
                  } )
    p2 <- grid.text( "http://research.physcon.uni-obuda.hu/NovekedesiGorbeRajzolo\nFerenci Tamás, 2018", 0.06, 0.035, just = "left",
                     draw = TRUE )
    return( list( p1 = p1, p2 = p2 ) )
  } )
  
  output$resultplot <- renderPlot( {
    temp <- plotInput()
    print( temp$p1 )
    grid.draw( temp$p2 )
  } )
  
  output$PlotDownloadPDF <- downloadHandler(
    filename = function() {
      paste0( "NovekedesiGorbe_", if( is.character( input$rawdata$name ) ) strsplit( input$rawdata$name, ".", fixed = TRUE)[[ 1 ]][ 1 ],
              "_", Sys.Date(), ".pdf" )
    },
    content = function( file ) {
      temp <- plotInput()
      trellis.device( file = file, device = "cairo_pdf", width = 12 )
      print( temp$p1 )
      grid.draw( temp$p2 )
      dev.off()
    } )
  
  output$PlotDownloadPNG <- downloadHandler(
    filename = function() {
      paste0( "NovekedesiGorbe_", if( is.character( input$rawdata$name ) ) strsplit( input$rawdata$name, ".", fixed = TRUE)[[ 1 ]][ 1 ],
              "_", Sys.Date(), ".png" )
    },
    content = function( file ) {
      temp <- plotInput()
      trellis.device( file = file, device = "png", width = 1200, height = 580 )
      print( temp$p1 )
      grid.draw( temp$p2 )
      dev.off()
    } )
  
}

shinyApp(ui = ui, server = server)