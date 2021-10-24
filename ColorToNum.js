'use strict';

// const colorBits = 3; // 9 Bit RGB
// const colorBits = 8; // 9 Bit RGB
// const colorBits = 16; // True Color
const colorBits = 256; // 24 Bit Color (Current)

const getPalette = () => {
  const palette = ['######'];
  for (let r = 0; r < colorBits; r++) {
    for (let g = 0; g < colorBits; g++) {
      for (let b = 0; b < colorBits; b++) {
        const colorHex = [
          r.toString(16).toUpperCase(),
          g.toString(16).toUpperCase(),
          b.toString(16).toUpperCase(),
        ];
        let colorStr = '#';
        colorHex.forEach((str) => {
          if (str.length < 2) {
            colorStr += '0' + str;
          } else {
            colorStr += str;
          }
        });
        palette.push(colorStr);
      }
    }
  }
  return palette;
};

const palette = getPalette();

const convertToHex = (num) => {
  if (0 < num && num <= Math.pow(colorBits, 3)) {
    const rmd = num % Math.pow(colorBits, 2);
    let redHex = Math.floor(num / Math.pow(colorBits, 2));
    console.log({ redHex, rmd });
    if (rmd === 0) {
      redHex -= 1;
    }
    const greenHex = rmd === 0 ? colorBits - 1 : Math.ceil(rmd / colorBits) - 1;
    const blueHex =
      rmd === 0 ? colorBits - 1 : rmd - (colorBits * greenHex + 1);
    const colorHex = [
      redHex.toString(16).toUpperCase(),
      greenHex.toString(16).toUpperCase(),
      blueHex.toString(16).toUpperCase(),
    ];
    let colorStr = '#';
    colorHex.forEach((str) => {
      if (str.length < 2) {
        colorStr += '0' + str;
      } else {
        colorStr += str;
      }
    });
    return colorStr;
  }
  return 'ERR';
};

/**
 *
 * @param hexColor color in HEX String without Hash (#)
 */
const convertFromHex = (hexColor) => {
  const parseLength = hexColor.length / 3;
  let parsed = [];
  for (let i = 0; i < 3; i++) {
    parsed.push(hexColor.substring(i * parseLength, (i + 1) * parseLength));
  }
  const r = parseInt(parsed[0], 16);
  const g = parseInt(parsed[1], 16);
  const b = parseInt(parsed[2], 16);
  return r * Math.pow(colorBits, 2) + g * colorBits + b + 1;
};

// TESTING ==> TODO: create Unit test for all 16777216 cases
console.log(palette[1], convertToHex(1));
console.log(palette[1], convertFromHex('000000'));
