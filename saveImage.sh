FILENAME=$1
EXTENSION="${FILENAME##*.}"
FILENAME="${FILENAME%.*}"
CLEANFILENAME="current/$FILENAME-$(date +'%Y%m%d%H%M%S').$EXTENSION"
UPLOAD=$2

# Make a directory to store current night images
mkdir -p current;
#cp "$1" "current/$FILENAME-$(date +'%Y%m%d%H%M%S').$EXTENSION";

#Subtract dark.PNG image from light image - this remove hot pixels from picture
#dark.PNG maust exist in allsky main directory
#To create dark.PNG - capture imeage with same parameters as normal but with lens cap on camera

convert "$1"  dark.PNG -compose minus_src -composite "$CLEANFILENAME";


if [ "$UPLOAD" = true ] ; then
    	echo "Resizing\n";
	
	# Create a thumbnail for live view
	# here we use image with hot pixels removed
	convert "$CLEANFILENAME" -resize 962x720 -gravity East -chop 2x0 "$FILENAME-resize.$EXTENSION";
	
	# Here's what I use with my ASI224MC
	#convert "$1" -resize 962x720 -gravity East -chop 2x0 "$FILENAME-resize.$EXTENSION";
	# Here's what I use with my ASI185MC (larger sensor so I crop the black around the image)
	#convert "$1" -resize 962x720 -gravity Center -crop 680x720+40+0 +repage "$FILENAME-resize.$EXTENSION";
	
	#echo "Uploading\n";
	#lftp sftp://user:password@host:/path/to/website -e "put $FILENAME-resize.$EXTENSION; bye"
	
	#Upload image to google drive - using gdrive from https://github.com/prasmussen/gdrive
	/home/pi/gdrive update 0BzUOSsm0CY_JTTB1Qjk2eEN4MlU "$FILENAME-resize.$EXTENSION"

fi
