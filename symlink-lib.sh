set -e

if [ -z ${LIBRARIES_DIR+x} ]; then
  echo "LIBRARIES_DIR must be set to the libraries directory path... exiting"
  exit 1
fi

if [ ! -d "$LIBRARIES_DIR" ]; then
  echo "$LIBRARIES_DIR does not exit... exiting"
  exit 1
fi

# name=telemetry/errors
# dest="$LIBRARIES_DIR/telemetry"

name=event_store/messaging
dest="$LIBRARIES_DIR/event_store"

if [ ! -d "$dest" ]; then
  mkdir -p "$dest"
fi

echo
echo "Symlinking $name"
echo "- - -"

if [ -h "$dest/messaging" ]; then
  for entry in $LIBRARIES_DIR/$name*; do
    echo "- removing symlink: $entry"
    rm $entry
  done
fi

echo "- creating symlinks"
ln -s $(PWD)/lib/$name* $dest

echo "- - -"
echo "($name done)"
echo
