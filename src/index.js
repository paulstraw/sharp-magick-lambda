const sharp = require('sharp')

const files = {
  'bmp': './test.bmp',
  'jpg': './test.jpg',
}

exports.handler = async (input) => {
  const metadata = await sharp(files[input.fileType]).metadata()

  return {
    statusCode: 200,
    body: JSON.stringify(metadata),
  }
}
