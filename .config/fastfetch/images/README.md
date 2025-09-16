# VozDeOuro Fastfetch Images

Place your custom images in this directory. Supported formats:
- PNG
- JPG/JPEG  
- GIF
- BMP

The fastfetch config will randomly select one image from this directory each time it runs.

You can add multiple images and fastfetch will pick a different one each time for variety!

## Example usage:
- Copy your favorite images here
- Name them descriptively (e.g., `logo1.png`, `avatar.jpg`, `cool-art.gif`)
- Fastfetch will automatically find and use them

The random selection is done using the `shuf` command in the fastfetch config.
