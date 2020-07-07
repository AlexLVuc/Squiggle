/*
 * Functions for completeing various tasks
 * Creator: Michael Jamieson
 * Date: July 4, 2020
 */

/* method for creating a java.awt front from ttf file
 *
 * @param ttf_name:  name of ".ttf" file
 * @param style:     style of font
 * @param size:      size of font
 */
public Font getFont(String ttf_name, int style, float size) {
  InputStream is = createInput(ttf_name);
  Font awtfont = null;
  try {
    awtfont = Font.createFont(Font.TRUETYPE_FONT, is).deriveFont(style, size);
  }
  catch(Exception e) {
    println("Failed to load font " + ttf_name);
  }
  return awtfont;
}

// method for making a random 8 digit session password
String makeSessionPassword() {
  String password = "";
  int temp;
  for (int i = 0; i < 8; i++) {
    temp = int(random(0, 3));
    switch (temp) {
      case 0:
        password += (char) int(random(48, 58));
        break;
      case 1:
        password += (char) int(random(65, 91));
        break;
      case 2:
        password += (char) int(random(97, 123));
        break;
    }
  } 
  return password;
}

int centerX() {
  return windowWidth / 2;
}

int centerY() {
  return windowHeight / 2;
}
