# ImfDataGui
Retrieve Data from IMF(IFS) with a RStudio Gui
The ImfDataGui is a wrapper GUI for the IMFData package. 
On the basis of keyworkds it searches the IFS dataset and return a list of possible
datasets (if any exist).

Selecting one (and pressing OK) returns the workspace a panel (of class data.frame) named according to the name provided as input to the function.

## Inputs
1. varname: Name of output data.frame
2. series: Keyword to search the IFS dataset
3. startdate: Starting date of data
4. enddate: Ending date of data

## Output

* data.frame containing a NxT panel with Date (date), countries (cc) and data (varname)

## Example
Retrieve GDP data from IFS and name the selection "gdp"

* ImfDataGui(varname="gdp",series='Gross Domestic Product',
               startdate='1980-01-01',
               enddate='2016-12-31')
               
               
