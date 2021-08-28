# sharp-magick-lambda

```bash
docker build -t sharp-magick-lambda . --progress=plain

docker run --name sharp-magick-lambda --rm -p 9000:8080 sharp-magick-lambda index.handler

curl -XPOST "http://localhost:9000/2015-03-31/functions/function/invocations" -d '{"fileType": "rw2"}'
# {"errorType":"Error","errorMessage":"Input file contains unsupported image format","trace":["Error: Input file contains unsupported image format"]}

curl -XPOST "http://localhost:9000/2015-03-31/functions/function/invocations" -d '{"fileType": "arw"}'
# {"errorType":"Error","errorMessage":"Input file contains unsupported image format","trace":["Error: Input file contains unsupported image format"]}

docker exec -ti sharp-magick-lambda identify Panasonic-GH4.RW2
# Panasonic-GH4.RW2 RW2 4624x3472 4816x3472+0+0 16-bit sRGB 18.6289MiB 0.000u 0:00.002

docker exec -ti sharp-magick-lambda identify Sony-A550.ARW
# Sony-A550.ARW ARW 4608x3072 4608x3072+0+0 16-bit sRGB 14.2822MiB 0.000u 0:00.001

docker exec -ti sharp-magick-lambda vips magickload Panasonic-GH4.RW2 pana.jpg && docker cp sharp-magick-lambda:/var/task/pana.jpg ~/Downloads/pana.jpg
# succeeds

docker exec -ti sharp-magick-lambda vips magickload Sony-A550.ARW sony.jpg && docker cp sharp-magick-lambda:/var/task/sony.jpg ~/Downloads/sony.jpg
# succeeds
```
