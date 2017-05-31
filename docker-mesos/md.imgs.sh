ls -l img/ |awk -F " " '{print "![](img/"$9" "$10" "$11")"}'
