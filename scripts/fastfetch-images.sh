#!/bin/bash
# VozDeOuro Fastfetch Image Setup
# This script helps you manage images for your fastfetch display

IMAGES_DIR="$HOME/.config/fastfetch/images"

echo "🖼️  VozDeOuro Fastfetch Image Manager"
echo "======================================"
echo ""
echo "Current images in $IMAGES_DIR:"

if [ -d "$IMAGES_DIR" ]; then
    ls -la "$IMAGES_DIR"/*.{png,jpg,jpeg,gif,bmp} 2>/dev/null || echo "No images found"
else
    mkdir -p "$IMAGES_DIR"
    echo "Created images directory: $IMAGES_DIR"
fi

echo ""
echo "💡 To add images:"
echo "   1. Copy your favorite images to: $IMAGES_DIR"
echo "   2. Supported formats: PNG, JPG, JPEG, GIF, BMP"
echo "   3. Fastfetch will randomly pick one each time!"
echo ""
echo "📁 Traditional location: ~/ffimg.png is also supported"
echo "🎨 Current VozDeOuro theme colors: Purple (#a52aff) and Blue (#2b4fff)"
