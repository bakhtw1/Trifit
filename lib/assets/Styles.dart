import 'package:flutter/material.dart';

/*
  This file can hold all of the custom colors / themes that we plan on using throughout the app (text styles, etc.)
*/

/*
  Trifit logo color from our m1 presentation, with opacities from 10% to 100% (50 and 900 respectively)

  If you run into the error 'The argument type 'Color?' can't be assigned to the parameter type 'Color' ' while
  using this (e.g. trifitColor[900]), end it with a ! to force unwrap the optional value (e.g. trifitColor[900]!)
*/
Map<int, Color> trifitColor =
  {
    50:Color.fromRGBO (165, 69, 204, .1),
    100:Color.fromRGBO(165, 69, 204, .2),
    200:Color.fromRGBO(165, 69, 204, .3),
    300:Color.fromRGBO(165, 69, 204, .4),
    400:Color.fromRGBO(165, 69, 204, .5),
    500:Color.fromRGBO(165, 69, 204, .6),
    600:Color.fromRGBO(165, 69, 204, .7),
    700:Color.fromRGBO(165, 69, 204, .8),
    800:Color.fromRGBO(165, 69, 204, .9),
    900:Color.fromRGBO(165, 69, 204, 1),
  };

TextStyle homeCardTitleTextStyle = const TextStyle(
  fontSize: 24,
);

TextStyle errorTextStyle = const TextStyle(
  color: Colors.red,
);

TextStyle cardBodyTextStyle = const TextStyle(
  fontSize: 16
);