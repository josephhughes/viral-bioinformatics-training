product_lines=`grep "product=" ~/Documents/Philippines/Datasets/sarscov2.gb | grep -o '".*"' |sort -u`
echo $product_lines 
