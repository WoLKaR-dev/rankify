//    Rankify is an Open Source AI app made to help brawl stars players reach higher ranks.
//    Copyright (C) 2026 WoLKaR-dev
//
//    This program is free software: you can redistribute it and/or modify
//    it under the terms of the GNU Affero General Public License as
//    published by the Free Software Foundation, either version 3 of the
//    License, or (at your option) any later version.
//
//    This program is distributed in the hope that it will be useful,
//    but WITHOUT ANY WARRANTY; without even the implied warranty of
//    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//    GNU Affero General Public License for more details.
//
//    You should have received a copy of the GNU Affero General Public License
//    along with this program.  If not, see https://www.gnu.org/licenses/

/**@type {Storage} */
let bucket;

// Inits an storage and returns if it was successfully initted or not
async function initStorage() {
  bucket = window.localStorage;
  if (bucket) return true;
  return false;
}

// Writes a new file given a name, content and an extension
async function writeFile(name, content, ext) {
  try {
    await bucket.setItem(name + "." + ext, content);
    console.log("[JS] File written successfully");
    return true;
  } catch (error) {
    console.log("[JS] An error ocurred writing file: " + error);
    return false;
  }
}

// Reads a created file given a name and an extension, and returns its content or "" if empty
async function readFile(name, ext) {
  try {
    var content = await bucket.getItem(name + "." + ext);
    console.log("[JS] File readed successfuly");
    return content ?? "";
  } catch (error) {
    console.log("[JS] An error ocurred reading file: " + error);
    return "";
  }
}
