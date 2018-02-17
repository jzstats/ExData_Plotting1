################################################################################
# WHAT YOU NEED TO KNOW BEFORE EXECUTING THIS SCRIPT
################################################################################

# DESCRIPTION:  The script 'plot4.R',
#               constructs and saves a multi-plot for selected variables
#               over a 2-days period of time. It contains the following 4 plots:
#                       1. a plot of 'Global_active_power' over datetime
#                       2. a plot of 'Voltage' over datetime
#                       3. a plot of Sub metering energy for all 3 variables:
#                          'Sub_metering_1', 'Sub_metering_2' and 'Sub_metering_3'
#                          over datetime
#                       4. a plot of 'Global_reactive_power' over datetime
#               Data was provided from the file "household_power_consumption.txt",
#               from the "Individual household electric power consumption Data Set",
#               that can be downloaded from 'UC Irvine Machine Learning Repository',
#               through this link:
#               "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
#               (the script will download the data file automatically,
#                if it doesn't exists in the working directory)
#
#               Plot 4, is created with the following 4 steps:
#                 1. Downloads and extracts the data file if missing
#                 2. Loads in R, part of the data file:
#                     'household_power_consumption.txt'
#                 3. Creates a data frame with the data needed
#                    to construct 'plot4.png'
#                 4. Constructs Plot 4 and saves it
#                    as 'plot4.png' in the working directory
#   
# The script was created:
#   - in RStudio Version 1.1.383
#   - with R version 3.4.3



################################################################################
# STEP 1: Downloads and extracts the data file if missing
################################################################################

# The file 'household_power_consumption.txt' should be in the working directory
# for STEP 2, when the data will be loaded in R from the file.
# If it doesn't exist, it is downloaded and extracted.
# (Informative messages explain the situation to the user)

if (!file.exists("household_power_consumption.txt")) {
      
      # downloads the zipped data file as 'data.zip'
      message("The file 'household_power_consumption.txt' ",
              "doesn't exists in the working directory. \n",
              "Trying to download the zipped data file ...")
      
      zip_data_url <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
      download.file(zip_data_url, "data.zip")
      
      message("\t ... zipped data file was successfully downloaded.")
      
      
      # unzips the 'data.zip' file
      message("Trying to extract the data file...")
      unzip("data.zip")
      
      # removes the 'data.zip' file
      file.remove("data.zip")
      
      message("\t ... data file was successfully extracted ",
              "and the zipped file removed. \n",
              "The data file 'household_power_consumption.txt'",
              " is present in the working directory.")
}




################################################################################
# STEP 2: Loads part of the data file, 'household_power_consumption.txt', in R
################################################################################
# Reads only the part of the data with the observations
# from 2 dates: '01/02/2007' and '02/02/2007'

project_data <- read.table(
      # Arguments that should be provided,
      # to read the data correctly : file, sep, na.strings, colClasses
      file = "household_power_consumption.txt",
      sep = ";",
      na.strings = "?",
      colClasses = c("character",   # 1. Date
                     "character",   # 2. Time
                     "numeric",     # 3. Global_active_power
                     "numeric",     # 4. Global_reactive_power
                     "numeric",     # 5. Voltage
                     "numeric",     # 6. Global_intensity
                     "numeric",     # 7. Sub_metering_1
                     "numeric",     # 8. Sub_metering_2
                     "numeric"),    # 9. Sub_metering_3
      
      # Argument that should be provided to read only the part of the file needed
      ## with this setup the first 66637 lines will be skipped,
      ## (1 line for the headers and 66636 lines for the first
      ##  unnecessary observations) then the it reads the next 2880 lines because:
      ##    (60 minutes)  x  (24 hours)  x  (2 days)  =  (2880 observations)
      skip = 66637,
      nrows = 2880,
      ## this setup assumes the default value of 'headers' argument
      ## so variables names will not be present in the 'project_data'
      header = FALSE,   # Can be omitted. The default value is the same.
      
      # Arguments that can be omitted, although they increase loading speed
      quote = "",
      comment.char = "",
      ## it is supplied just to highlight the decimal mark used in the data file
      dec = "."   # Can be omitted. The default value is the same.
)




################################################################################
# STEP 3: Creates a data frame with the data needed to construct 'plot4.png'
################################################################################

# Creates a new variable for datetime in POSIXct format as 'datetime',
# based on 'Date' and 'Time' variables from 'project_data'
datetime <- strptime(
      x = paste(project_data[[1]],  # Date
                project_data[[2]]), # Time
      format = "%d/%m/%Y %H:%M:%S"
)

# Creates a data frame only with the required variables for 'plot4.png'
target_data <- data.frame(
      "Datetime" = datetime,
      "Global_active_power" = project_data[[3]],
      "Global_reactive_power" = project_data[[4]],
      "Voltage" = project_data[[5]],               
      "Sub_metering_1" = project_data[[7]],
      "Sub_metering_2" = project_data[[8]],
      "Sub_metering_3" = project_data[[9]]
)




################################################################################
# STEP 4: Constructs Plot 4 and saves it as 'plot4.png' in the working directory
################################################################################

# Opens a new png graphical device, with resolution 480x480 pixels.
png(filename = "plot4.png", width = 480, height = 480)

# Sets the layout of the graphical device,
par(mfrow = c(2,2))

with(target_data, {
      
      # constructs the first plot on top-left
      plot(x = Datetime,
           y = Global_active_power,
           type = "l",
           xlab = "",
           ylab = "Global Active Power")
      
      # constructs the second plot on top-right
      plot(x = Datetime,
           y = Voltage,
           type = "l",
           xlab = "datetime",
           ylab = "Voltage")
      
      # construct the third plot on bottom-left
      ## creates axis and labels but doesn't plot anything in it
      plot(x = Datetime, y =  Sub_metering_1, 
           type = "n", # to avoid plotting any points
                       # but will use the values to specify 
                       # the x-axis and y-axis limits
      xlab = "", ylab = "Energy sub metering")
      
      # plots the lines for the target variables over the datetime
      points(x = Datetime, y = Sub_metering_1, type = "l", col = "black")
      points(x = Datetime, y = Sub_metering_2, type = "l", col = "red")
      points(x = Datetime, y = Sub_metering_3, type = "l", col = "blue")
      
      # adds a legend to indicate which color corresponds to each variable
      legend(x = "topright",
             legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"),
             col = c("black", "red", "blue"),
             lty = 1,
             # the legend in this box has no border line around it
             bty = "n")
      
      # constructs the fourth plot on bottom-right
      plot(x = Datetime,
           y = Global_reactive_power,
           type = "l",
           xlab = "datetime",
           ylab = "Global_reactive_power")
})

# Closes the graphical device and saves Plot 4 as 'plot4.png'
dev.off()




message("SUCCESSfully created 'plot4.png' in the working directory.")
# THE END ######################################################################

