# Mach3AutoXYProbing
(c) James D. Stallard 2017

A custom button script for Artsoft Mach3 that allows for Automatic Tool Zeroing in the X and Y Axes

# Notes
Script converts mm to inches automatically by reading your machine's native unit settings irrespective of G20/G21

 You MUST configure the following variables:
 
	intProbeDiameter
	
	MUST BE SET IN MM
	
	strProbeAction

	MUST BE ONE OF "Xpos", "Xneg", "Ypos", "Yneg"

All other variables can be left at their defaults or tuned to suit

The script allows you to run a metric and imperial units setup on the same machine (common in Europe), but in different Mach3 profiles without having to edit intProbeDiameter each time you switch units
