# sharp-magick-lambda

```bash
docker build -t sharp-magick-lambda . --progress=plain

docker run --name sharp-magick-lambda --rm -p 9000:8080 sharp-magick-lambda index.handler

curl -XPOST "http://localhost:9000/2015-03-31/functions/function/invocations" -d '{"fileType": "jpg"}'
# {"statusCode":200,"body":"{\"format\":\"jpeg\",\"width\":513,\"height\":767,\"space\":\"srgb\",\"channels\":3,\"depth\":\"uchar\",\"density\":72,\"chromaSubsampling\":\"4:4:4\",\"isProgressive\":false,\"hasProfile\":false,\"hasAlpha\":false}"}

curl -XPOST "http://localhost:9000/2015-03-31/functions/function/invocations" -d '{"fileType": "bmp"}'
# BEFORE: {"errorType":"Error","errorMessage":"Input file contains unsupported image format","trace":["Error: Input file contains unsupported image format"]}
# AFTER: {"statusCode":200,"body":"{\"format\":\"magick\",\"width\":200,\"height\":200,\"space\":\"srgb\",\"channels\":3,\"depth\":\"uchar\",\"density\":72,\"isProgressive\":false,\"pages\":1,\"pageHeight\":200,\"hasProfile\":false,\"hasAlpha\":false}"}

docker exec -ti sharp-magick-lambda identify test.jpg
# test.jpg JPEG 513x767 513x767+0+0 8-bit sRGB 106981B 0.000u 0:00.001

docker exec -ti sharp-magick-lambda identify test.bmp
# test.bmp BMP3 200x200 200x200+0+0 8-bit sRGB 120054B 0.000u 0:00.000

docker exec -ti sharp-magick-lambda vips magickload test.jpg test2.jpg && docker cp sharp-magick-lambda:/var/task/test2.jpg ~/Downloads/test2.jpg
# succeeds

docker exec -ti sharp-magick-lambda vips magickload test.bmp test2.bmp && docker cp sharp-magick-lambda:/var/task/test2.bmp ~/Downloads/test2.bmp
# succeeds
```
