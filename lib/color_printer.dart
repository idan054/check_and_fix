import 'package:flutter/material.dart';
import 'package:rich_console/rich_console.dart';

void printGreen(String text) => printRich(text, foreground: Colors.green, bold: true);
void printYellow(String text) => printRich(text, foreground: Colors.yellow, bold: true);
void printOrange(String text) => printRich(text, foreground: Colors.orange, bold: true);
void printRed(String text) => printRich(text, foreground: Colors.red, bold: true, slowBlink: true);
void printBrown(String text) => printRich(text, foreground: Colors.brown);
void printLightBlue(String text) => printRich(text, foreground: Colors.blue[200], bold: true);
void printDarkBlue(String text) => printRich(text, foreground: Colors.blue[800], bold: true);
void printPurple(String text) => printRich(text, foreground: Colors.purple, bold: true);
void printWhite(String text) => printRich(' $text ', foreground: Colors.white, bold: true, framed: true);
void printBlack(String text) => printRich(text, foreground: Colors.black, bold: true);