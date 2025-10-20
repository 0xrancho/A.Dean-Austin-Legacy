#!/usr/bin/env python3
"""
Simple script to convert multiple images to a PDF using PIL/Pillow
"""
import sys
from PIL import Image
import os

def images_to_pdf(image_paths, output_pdf):
    """Convert a list of image paths to a single PDF"""
    if not image_paths:
        print("No images provided")
        return

    # Sort images by filename to maintain order
    image_paths = sorted(image_paths)

    # Open all images
    images = []
    for img_path in image_paths:
        img = Image.open(img_path)

        # Handle EXIF orientation by transposing the image
        try:
            # Get EXIF orientation tag
            exif = img.getexif()
            orientation = exif.get(0x0112, 1)  # 0x0112 is the orientation tag

            # Apply rotation based on EXIF orientation
            if orientation == 3:
                img = img.rotate(180, expand=True)
            elif orientation == 6:
                img = img.rotate(270, expand=True)
            elif orientation == 8:
                img = img.rotate(90, expand=True)
        except:
            # If EXIF reading fails, just continue
            pass

        # Convert to RGB (PDF requires RGB)
        if img.mode != 'RGB':
            img = img.convert('RGB')
        else:
            # Create a new image to avoid EXIF issues
            img = img.convert('RGB')
        images.append(img)

    # Save as PDF
    if len(images) == 1:
        images[0].save(output_pdf, 'PDF', resolution=100.0)
    else:
        images[0].save(output_pdf, 'PDF', resolution=100.0, save_all=True, append_images=images[1:])

    print(f"Created PDF: {output_pdf}")
    print(f"  Pages: {len(images)}")

if __name__ == "__main__":
    if len(sys.argv) < 3:
        print("Usage: create_pdf.py output.pdf image1.jpg image2.jpg ...")
        sys.exit(1)

    output_pdf = sys.argv[1]
    image_paths = sys.argv[2:]

    images_to_pdf(image_paths, output_pdf)
