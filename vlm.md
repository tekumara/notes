# vlm

[SmolVLM](https://huggingface.co/blog/smolervlm) on macos:

```
uvx --from mlx-vlm mlx_vlm.generate --model HuggingfaceTB/SmolVLM-500M-Instruct --max-tokens 400 --temp 0.0 --image https://huggingface.co/datasets/huggingface/documentation-images/resolve/main/vlm_example.jpg --prompt "What is in this image?"
```

Moondream:

```python
# /// script
# dependencies = [
#   "moondream",
# ]
# ///
import moondream as md
from PIL import Image

# Initialize with local model path. Can also read .mf.gz files, but we recommend decompressing
# up-front to avoid decompression overhead every time the model is initialized.
model = md.vl(model="path/to/moondream-2b-int8.mf")

# Load and process image
image = Image.open("path/to/image.jpg")
encoded_image = model.encode_image(image)

# Generate caption
caption = model.caption(encoded_image)["caption"]
print("Caption:", caption)

# Ask questions
answer = model.query(encoded_image, "What's in this image?")["answer"]
print("Answer:", answer)
```
