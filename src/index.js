const sharp = require('sharp')

const files = {
  'bmp': './test.bmp',
  'jpg': './test.jpg',
  'rw2': './Panasonic-GH4.RW2',
  'arw': './Sony-A550.ARW',
}

exports.handler = async (input) => {
  const metadata = await sharp(files[input.fileType]).metadata()

  return {
    statusCode: 200,
    body: JSON.stringify(metadata),
  }
}
