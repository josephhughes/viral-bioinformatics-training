
## Examples in the previous works

In this section, you have the chance to take a look how figures in
published scientific papers or reports were made by using R. The goal
here is to practice the skills you just learned in the previous section.

``` r
require(tidyverse)
require(lubridate)
require(ggpubr)

require(treeio)
require(ggtree)
require(ggseqlogo)
```

### Example 1. Number of COVID-19 cases with % of sequenced cases in the Philippines

The figure illustrates the case number by **line** and the proportion of
monthly sequenced samples (number of sequences/number of cases) by
**bar**.

#### Date sources:

1.  **Sequencing_data.csv**
    -   time interval (year_month)
    -   monthly number of sequences (no)
    -   monthly cases (cases)
    -   date (first date of each interval)
    -   proportion of sequenced % (prop)
2.  **JHU_daily_case.csv**
    -   the file is a subset of [JHU COVID-19 data
        base](https://coronavirus.jhu.edu/map.html) prepared on October
        2nd
    -   you will be using *date* and *case_07* variables
    -   case_07 is the mean cases in a 7 days interval

#### Hints:

1.  Import both csv files by `read.csv` (setting `header=TRUE`).

2.  Use `geom_line` to draw a line for the case data (JHU_daily_case),
    followed by x as *date*, y as *case_07*.

3.  Instead of a typical barplot, we will do a [Lollipop
    plot](https://r-graph-gallery.com/lollipop-plot.html) for % of
    sequenced cases here. To do a Lollipop plot using ggplot, we need
    `geom_segment` and `geom_point` both taking Sequencing_data as
    `data`. Set the x and y as follows:

    -   `geom_segment`: x = date, xend = date, y = 0, yend = prop\*5000
    -   `geom_point`: x = date, y = prop\*5000

4.  Transform all **date** from character to numeric format by the
    package *lubridate* function `ymd()`. That is, for example
    `aes( x = ymd(date), y = cases_07 )`.

5.  Generate a y-axis on the right by adding
    `sec.axis = sec_axis(~ ./5000, name = "Proportion of sequenced (%)")`
    in the `scale_y_continuous()`.

#### Results:

Part 1

``` r
seq_data  <- read.csv( file = "Sequencing_data.csv", header = TRUE )
case_data <- read.csv( file = "JHU_daily_case.csv", header = TRUE )

last_date <- max( case_data$date )
```

Part 2

``` r
ggplot() +     
  geom_line( data = case_data, 
             aes( x = ymd(date), y = cases_07 ), 
             size = 1.1, color = "#7f7f7f" ) +
  geom_segment( data = seq_data, 
                aes( x = ymd(date), xend = ymd(date), y = 0, yend = prop*5000 ), 
                color = "#d62728", alpha = 0.2, size = 5 ) +
  geom_point( data = seq_data, 
              aes( x = ymd(date),  y = prop*5000 ), 
              size = 5, color = "#d62728", alpha = 1 ) +
  scale_x_date( date_labels = "%b %d \n %y" ) + 
  scale_y_continuous( sec.axis = sec_axis(~ ./5000, name = "Proportion of sequenced (%)"),
                      limits = c(0, 40000) ) +
  labs( x="", y="Cases (7-day avg)") + 
  theme_classic() +
  theme( axis.line.y = element_blank(),
         axis.text    = element_text(size = 14),
         axis.title   = element_text(size = 14) ) +
  ggtitle( paste0( "Last date: ",  last_date ) )
```

<img src="2_advanced_files/figure-gfm/figure 1b-1.png" width="768" style="display: block; margin: auto;" />

###### The gray line indicates the mean cases in a 7 days window based on the JHU data base, whereas the red bars indicate the estimated percentage of sequenced samples among cases in a month.

#### Notes:

1.  Put the text above the plot by `ggtitle()`. Here we provide the last
    time point.

2.  The right y-axis was scaled with a factor of 5000 (you may change
    the number and see what happens).

3.  Label the x-axis by `"%b %d \n %y"`. `\n` represents a new line, the
    rest generates month (brief version), date and year.

4.  `#7f7f7f` is the RGB hexadecimal color value for gray, and `#d62728`
    leads to red. `alpha` determines the shade of color.

5.  You can find the same figure presented in the report ([Figure
    4](https://geco-ph.github.io/GECO-covid/#SARS-CoV-2_sequencing_in_the_Philippines)).

### Example 2. Expansion of BA.1 and BA.2 lineages in the Philippines

The figure uses size of **dots** to represent the proportions of
isolated SARS-CoV-2 lineage in a week in a administrative region. The
lineage will be distinguished by color, while time and location
variables will be the x and y, respectively.

#### Date sources:

1.  **Division_variant.csv**
    -   virus lineage - BA.1 or BA.2 (lineage)
    -   proportion of isolates per week per location (prop)
    -   17 administrative regions (division)
    -   time interval as week (yr_week)
2.  **Geo_admin.csv**
    -   the table will help us order the regions as the
        [paper](https://academic.oup.com/ve/article/8/2/veac078/6672639)
        using *working_no* column
    -   the idea of the order is to arrange the regions by island
        group - Luzon, Visayas, Mindanao

#### Hints:

1.  Import both csv files by `read.csv` as previously.

2.  We would like to arrange the y variable (here, division) in a
    pre-specified order, changing the location variable in the dataframe
    from pure character to **factor** data class would be one of the
    easiest ways to do so with ggplot. `factor` function usually takes
    the “x” and “levels”; **x** is the input, **levels** indicates how
    we order them. The **levels** we are interested in can be manually
    entered as below. You can find another way to prepare the ordered
    regions later.

``` r
levels_of_interest = c( "National Capital Region", "Ilocos", 
                        "Cordillera Administrative Region", "Cagayan Valley",  
                        "Central Luzon", "Calabarzon", "Mimaropa", "Bicol",
                        "Western Visayas", "Central Visayas", "Eastern Visayas", 
                        "Zamboanga Peninsula", "Northern Mindanao", "Davao Region",
                        "Soccsksargen", "Caraga", 
                        "Bangsamoro Autonomous Region In Muslim Mindanao")
```

3.  Use `geom_point` to place the dots with `x = yr_week`,
    `y = division`. Note that to distinguish the two lineages we add
    `fill = lineage, size = prop` in the `aes(...)`.

#### Results:

Part 1

``` r
location_variant <- read.csv( "Division_variant.csv", header = TRUE )

geo_admin <- read.csv( "Geo_admin.csv", header = TRUE )

# this generates the same `levels_of_interest` as we manually order the divisions
levels_of_interest <- rev( geo_admin$GISAID[ match( seq(1,17), geo_admin$working_no ) ] )

location_variant$division <- factor( x      = location_variant$division,
                                     levels = levels_of_interest )

# check the data type by - 
# class(location_variant$division)
```

Part 2

``` r
ggplot( ) + 
  geom_point( data = location_variant, 
              aes( x = yr_week, y = division, fill = lineage, size = prop), 
              shape = 21, alpha = 0.75 ) + 
  theme_bw() + 
  theme( panel.grid.major.x = element_blank(),
         axis.title = element_blank(),
         axis.text = element_text(size = 7),
         axis.text.x = element_text(angle = 45, vjust = 0.5)) +
  scale_fill_manual( values = c( "#d8b365", "#5ab4ac" ) ) +
  xlab( "Year_Week" )
```

<img src="2_advanced_files/figure-gfm/figure 2b-1.png" width="768" style="display: block; margin: auto;" />

###### Visualisation of locations of BA.1/BA.2 samples against time. X-axis labels represent year plus week and circle sizes are scaled to the proportion of the lineage per location per week.

#### Notes:

1.  `#7f7f7f`, yellow; `#5ab4ac`, green.

2.  `rev()` is used to reverse the order of elements. Try to do another
    plot by a different `levels_of_interest <- ...` without `rev`, that
    is,
    `levels_of_interest <- geo_admin$GISAID[ match( seq(1,17), geo_admin$working_no ) ]`.
    How would the y-axis change?

3.  Some effort should be made to correct the legend; BA.1/BA.2, instead
    of BA1/BA2, is the correct way to name the virus lineage.

4.  You can find the original figure presented in the supplementary
    figure of the
    [paper](https://academic.oup.com/ve/article/8/2/veac078/6672639#supplementary-data).

### Example 3. Proportions of nucleodite at virus glycoprotein cleavage sites

Using NGS methods, we often found a mixture of nucleotides at a distinct
genomic position. If multiple nucleodites, i.e., A, T, C, G, account for
substantial proportions at a site, it may suggest intra-host diversity,
contamination or error generated during the processes of sequencing.
It’s not usually to present the raw data containing the proportions of
different nucleotides to validate mutations detected with the consensus
sequence. Here, we will make a “sequence logo” to illustrate the genetic
composition of glycoprotein cleavage sites in an influenza sample (not
SARS-CoV-2, sorry!) facilitated by a R package
[ggseqlogo](https://omarwagih.github.io/ggseqlogo/).

#### Date sources:

We will manually type the counts of nucleotide at each position in the
alignemnt, which can be acquired by
[IGV](https://software.broadinstitute.org/software/igv/) or
[Tablet](https://ics.hutton.ac.uk/tablet/) after loading the BAM files.
The codes below will create a matrix with 5 rows indicating A, C, G, T
and indel, and 12 columns indicating 12 nucleodite positions spanning
1015-1026 positions in the HA protein. The 12 nucleodite positions
translate to 4 amino acid residues.

``` r
mx_nt <- matrix( c( 5987,2,77,26,183,
                    168,2,5862,3,127,
                    5564,1,238,17,374,
                    12,1,6052,8,866,
                    527,1,4215,12,1424,
                    1259,0,4418,8,619,
                    5379,4,629,7,147,
                    5892,7,158,10,91,
                    5921,9,143,2,103,
                    5899,6,123,19,122,
                    23,6,5963,3,158,
                    5934,1,52,13,180),
                 nrow = 5 ) 

# naming the row is required by the package 
row.names( mx_nt ) = c( "A", "C", "G", "T", "" )
```

#### Hints:

1.  Because the number of reads covering each position (‘depth’) and the
    proportions are equally important, we will generate a barplot
    showing the depth of coverage along with the sequence logo. A
    dataframe summing total counts in each position (also the sum of
    each column in the matrix) can be created by -
    `cov <- data.frame( x = seq(1,12), y =  apply(mx_nt, 2, sum) )`.

2.  Generate the logo by `ggseqlogo( mx_nt, method = 'prob' )`

3.  Generate the barplot by
    `ggplot() + geom_bar( data=cov, aes(x, y), stat='identity', fill='grey')`.

4.  Combine the two ggplot elements by
    `ggarrange( fig_logo, fig_cov, ncol = 1, nrow = 2, align = 'v' )` .

#### Results:

Part 1

``` r
mx_nt <- matrix( c( 5987,2,77,26,183,
                    168,2,5862,3,127,
                    5564,1,238,17,374,
                    12,1,6052,8,866,
                    527,1,4215,12,1424,
                    1259,0,4418,8,619,
                    5379,4,629,7,147,
                    5892,7,158,10,91,
                    5921,9,143,2,103,
                    5899,6,123,19,122,
                    23,6,5963,3,158,
                    5934,1,52,13,180),
                 nrow = 5 ) 

row.names( mx_nt ) = c( "A", "C", "G", "T", "" )

cov <- data.frame( x = seq(1,12), y =  apply(mx_nt, 2, sum) )
```

Part 2

``` r
fig_logo = 
  ggseqlogo( data = mx_nt, 
             method = 'prob' ) + 
  theme( axis.text.x = element_blank() ) +
  scale_x_continuous(expand = c(0,0) ) +
  ylab("Proportion")
  

fig_cov = 
  ggplot() +
  geom_bar( data = cov, 
            aes(x, y), 
            stat='identity', fill='grey') + 
  theme_logo() + 
  scale_x_continuous( breaks=1:12, expand = c(0,0), labels = seq(1015, 1026) ) +
  xlab("") + ylab("Coverage")
```

Part 3

``` r
ggarrange( fig_logo, fig_cov, ncol = 1, nrow = 2, align = 'v' )
```

<img src="2_advanced_files/figure-gfm/figure 3c-1.png" width="480" style="display: block; margin: auto;" />

###### Sequence logos and depth of coverage (number of reads mapped to the reference) were derived from a nanopore library using A1 sample, where A/chicken/Taiwan/A1/2019 (H5N2) was identified. 12 nucleotide positions containing residues -4 to -1 at the cleavage site are shown (nucleotide positions 1015-1026).

#### Notes:

1.  The putative amino acids in the region are RGKR. You can verify this
    by package `seqinr`
    (`seqinr::translate(c("A","G","A", "G", "G", "G", "A", "A", "A", "A", "G", "A"))`).

2.  You can find the original figure presented in the supplementary
    figure of the
    [paper](https://academic.oup.com/ve/article/6/1/veaa037/5831843).

### Example 4. SARS-CoV-2 Phylogenetic tree and the time of introdution

The figure contains a time-scale phylogenetic tree, overlaid with a
distribution of the estimated introduction time. The node corresponding
to the introduction (and also the common ancestor of Philippine
isolates) should match the median of the distribution.

#### Date sources:

1.  **BA2_beast_anno.tre**

    -   a time-scaled phylogeny with 365 taxa (2 South Africa, 1 India
        and 362 Philippines) summarized from sample trees generated by
        [BEAST](https://beast.community).

2.  **BA2_beast_tmrca.txt**

    -   tMRCAs (time of the most recent common ancestor) estimated and
        logged by different sample trees during the MCMC process.

3.  **Metadata_PH.tsv**

    -   simplified metadata of the SARS-CoV2-2 Philippine isolates
    -   includes strain (isolate name) and division (PH administrative
        region)

4.  **Geo_admin.csv**

    -   the same file we used in *Example 2*

#### Hints:

1.  Import the annotated tree by `read.beast`. We then use `fortify` to
    extract parameters from the tree -
    `beast_tree_df <- fortify( beast_tree )`.

2.  Import the logged TMRCAs by `read.table` and import Metadata_PH by
    `read.table` but with `sep="\t"`; both set `header = T`. Read in
    Geo_admin.csv as *Example 2*.

3.  The following lines will classify taxa based on their countries, and
    the Philippine isolates will be further classified into 3 island
    groups. We will color the three groups with different colors.

``` r
# to find tips/taxa which are Philippine isolates
ph_tip_i <- which( beast_tree_df$isTip & grepl( "Philippines", beast_tree_df$label ) )

# to map the strain name to metadata 
div_m <- match( gsub( "__.*", "", beast_tree_df$label[ ph_tip_i ] ), meta$strain )

# to create a column to code the color
beast_tree_df$geo                                               <- NA
# the two non-PH countries in the tree
beast_tree_df$geo[ grep( "SouthAfrica", beast_tree_df$label ) ] <- "South Africa"
beast_tree_df$geo[ grep( "India", beast_tree_df$label ) ]       <- "India"
# the Philippines divisions
beast_tree_df$geo[ ph_tip_i ]                                   <- meta$division[ div_m ]

# to put Philippine divisions into 3 different groups
uni_division <- unique( beast_tree_df$geo[ ph_tip_i ] )

ph_adm_island <- geo_admin$island_group[ match( uni_division, geo_admin$GISAID ) ]

beast_tree_df$geo[ ph_tip_i ] <- ph_adm_island[ match( beast_tree_df$geo[ ph_tip_i ], uni_division ) ]
```

4.  The Bayesian processes generated some branches with negative length,
    which, biologically, do not make sense. To correct this in the
    figure, we force the negative branch to length zero using
    `beast_tree@phylo$edge.length[ beast_tree@phylo$edge.length <0 ] = 0`.
    Note this change does not affect the node we are interested in, the
    tMRCA of the Philippine BA.2, which represents the introduction time
    of the viruses.

5.  Use
    `ggtree( beast_tree,  right = TRUE, mrsd = "2022-01-08", size = 0.25 ) %<+% beast_tree_df`
    to draft the tree. The point with color can then be added by
    `geom_tippoint( aes( fill = geo), shape = 21 )`. The `%<+%` is used
    to supplement data linked to the tree.

6.  To generate a distribution plot directly corresponded to the time
    tree, another ggplot element must be used. A new dataframe should be
    prepared by
    `age_dist <- density(mrca_tab$age); df_age_dist <- data.frame( x = age_dist$x, y = age_dist$y )`.

7.  The other ggplot element then looks like -
    `ggplot( ) + geom_area( data = subset( df_age_dist, x >=2021.8473 & x<= 2021.9094 ), aes(x = x, y = y), alpha = 0.7 ) + geom_density( data = mrca_tab, aes(x = age) )`.
    The `geom_density` draws the distribution of the inferred tMRCAs,
    whereas `geom_area` highlights the 95 credible interval
    (2021.8473-2021.9094, similar concept of confident interval).

8.  Zoom the two figures to the same view window by adding
    `coord_cartesian( xlim = c(2021.835, 2022.015) ) to both ggplot elements`.
    Finally, combine the tree and the tMRCA distribution by
    `ggarrange( fig_tree, fig_mrca, align='v', ncol=1 )`.

#### Results:

Part 1

``` r
beast_tree <- read.beast( file = "BA2_beast_anno.tre" )

beast_tree_df <- fortify( beast_tree )


mrca_tab <- read.table( file = "BA2_beast_tmrca.txt", header = T )

meta <- read.table( file = "Metadata_PH.tsv", sep = "\t" , header = T)

geo_admin <- read.csv( file = "Geo_admin.csv", header = TRUE )
```

Part 2 (codes here have been shown in the Hints-3)

``` r
ph_tip_i <- which( beast_tree_df$isTip & grepl( "Philippines", beast_tree_df$label ) )

div_m <- match( gsub( "__.*", "", beast_tree_df$label[ ph_tip_i ] ), meta$strain )

beast_tree_df$geo                                               <- NA
beast_tree_df$geo[ grep( "SouthAfrica", beast_tree_df$label ) ] <- "South Africa"
beast_tree_df$geo[ grep( "India", beast_tree_df$label ) ]       <- "India"
beast_tree_df$geo[ ph_tip_i ]                                   <- meta$division[ div_m ]

uni_division <- unique( beast_tree_df$geo[ ph_tip_i ] )

ph_adm_island <- geo_admin$island_group[ match( uni_division, geo_admin$GISAID ) ]

beast_tree_df$geo[ ph_tip_i ] <- ph_adm_island[ match( beast_tree_df$geo[ ph_tip_i ], uni_division ) ]
```

Part 3

``` r
beast_tree@phylo$edge.length[ beast_tree@phylo$edge.length <0 ] = 0

fig_tree = 
  ggtree( tr = beast_tree,  
          right = TRUE, mrsd = "2022-01-08", size = 0.25 ) %<+% beast_tree_df +
  geom_tippoint( aes( fill = geo), shape = 21 ) + 
  scale_y_continuous( expand = c(0.01,0) ) +
  coord_cartesian( xlim = c(2021.835, 2022.015) ) + 
  theme( legend.title    = element_blank(),
         legend.position = c(0.15, 0.5) )

fig_tree
```

<img src="2_advanced_files/figure-gfm/figure 5c-1.png" width="672" />

Part 4

``` r
age_dist    <- density(mrca_tab$age)
df_age_dist <- data.frame( x = age_dist$x, y = age_dist$y )

fig_mrca = 
ggplot( ) + 
  geom_area( data = subset( x = df_age_dist, x >=2021.8473 & x<= 2021.9094 ),
             aes( x = x, y = y), alpha = 0.7 ) +
  geom_density( data = mrca_tab, 
                aes(x = age) ) +
  theme_classic() + 
  theme( axis.line.y = element_blank(),
         axis.text.y = element_blank(), 
         axis.ticks.y = element_blank(),
         axis.title = element_blank() ) +
  coord_cartesian( xlim = c(2021.835, 2022.015) ) +
  scale_y_continuous( expand = c(0,0) )

fig_mrca
```

<img src="2_advanced_files/figure-gfm/figure 5d-1.png" width="672" />

Part 5

``` r
ggarrange( fig_tree, fig_mrca, align = 'v', ncol = 1, heights = c(5,1) )
```

<img src="2_advanced_files/figure-gfm/figure 5e-1.png" width="576" style="display: block; margin: auto;" />

###### Introduction of the BA.2 lineage in the Philippines. The time-scaled tree was inferred by BEAST using BA.2 genomes isolated in the Philippines along with the genomes of early global BA.2 viruses. The estimated tMRCAs with 95 per cent HPD illustrated by the grey area are aligned with the phylogenetic tree. Tips are coloured according to the location of isolation.

#### Notes:

1.  `heights = c(5,1)` in the `ggarrange` function adjusts the relative
    heights of the two ggplot elements.

2.  You can find the original figure presented in the
    [paper](https://academic.oup.com/ve/article/8/2/veac078/6672639#377698438).
    Compared with the figure in the paper, the example codes here omit
    the vertical lines which indicate the start of the month (can be
    done by `geom_vline()`) and setting colors for the tips
    (`scale_fill_manual()`).
