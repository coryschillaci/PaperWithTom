(* ::Package:: *)

(************************************************************************)
(* This file was generated automatically by the Mathematica front end.  *)
(* It contains Initialization cells from a Notebook file, which         *)
(* typically will have the same name as this file except ending in      *)
(* ".nb" instead of ".m".                                               *)
(*                                                                      *)
(* This file is intended to be loaded into the Mathematica kernel using *)
(* the package loading commands Get or Needs.  Doing so is equivalent   *)
(* to using the Evaluate Initialization Cells menu command in the front *)
(* end.                                                                 *)
(*                                                                      *)
(* DO NOT EDIT THIS FILE.  This entire file is regenerated              *)
(* automatically each time the parent Notebook file is saved in the     *)
(* Mathematica front end.  Any changes you make to this file will be    *)
(* overwritten.                                                         *)
(************************************************************************)



(* :Title: BlockOptions *)
(* :Context: BlockOptions` *)
(* :Author: Mark A. Caprio, Department of Physics, University of Notre Dame *)
(* :Summary: Dynamic scoping structure for options associated with a symbol. *)
(* :Copyright: Copyright 2013, Mark A. Caprio *)
(* :Package Version: 2.1 *)
(* :Mathematica Version: 6.0 *)
(* :History:
Extracted from MCFlowControl January 12, 2005.
V1 .0, January 22, 2005. MathSource No. 5549.
 V1 .1, March 8, 2005.  Attribute HoldAll relaxed to HoldRest.
V1.2, January 9, 2006.  Added WithOptions.
V2.0, June 22, 2011. WithOptions expanded to provide scoping and setting of options for several symbols simultaneously.  DoForEach/TableForEach iteration replaced with simple Do/Table (requires Mathematica 6 or above).
Restructured to load from init.m file.
V2.1, January 3, 2013. WithOptions syntax modified to accept argument in form of rules {symbol1->options1,symbol2->options2,...}.
*)


BeginPackage[
"BlockOptions`"
];


Unprotect[Evaluate[$Context<>"*"]];


BlockOptions::usage="BlockOptions[{symbol1,...},body] evaluates body with dynamic scoping for Options[symbol1], ..., making local any changes to these options.";
WithOptions::usage="WithOptions[{symbol1->{option1->value1,...},symbol2->{option1->value1,...},...},body] evaluates body with dynamic scoping for Options[symbol1], ..., making local any changes to these options.  Moreover, SetOptions is called to apply the specified default values.  A legacy syntax WithOptions[{{symbol1,{option1->value1,...}},{symbol2,{option1->value1,...}},...},body] is also supported.";


Begin["`Private`"];





SetAttributes[BlockOptions,HoldRest];


BlockOptions[x_/;!MatchQ[x,{___Symbol}],_]:=Message[BlockOptions::needlist];
BlockOptions[_]:=Message[BlockOptions::numargs];
BlockOptions[_,_,__]:=Message[BlockOptions::numargs];


BlockOptions::needlist="The first argument of BlockOptions must be a list of symbols.";BlockOptions::numargs="BlockOptions must be called with exactly two arguments.";


BlockOptions[IdentifierList:{___Symbol},Body_]:=Module[
{SavedOptions,Identifier,EvaluatedBody,IsProtected,Aborted},
AbortProtect[

(* Save options *)
If[TrueQ[$Debug],Print["BlockOptions: ",IdentifierList]];  (* private debug flag BlockOptions`Private`$Debug *)
Do[
SavedOptions[Identifier]=Options[Identifier],
{Identifier,IdentifierList}
];

(* Evaluate body *)
Aborted=False;
CheckAbort[
EvaluatedBody=Body,
Aborted=True
];

(* Restore options *)
Do[
IsProtected=MemberQ[Attributes[Evaluate[Identifier]],Protected];
If[IsProtected,Unprotect[Evaluate[Identifier]]];
Options[Identifier]=SavedOptions[Identifier];
If[IsProtected,Protect[Evaluate[Identifier]]],
{Identifier,IdentifierList}
];
];

(* Return value *)
(* Passes through abort, and also explicitly returns $Aborted in case Abort[] is suppressed *)
If[Aborted,Abort[];$Aborted,EvaluatedBody]
];


SetAttributes[WithOptions,HoldRest];


WithOptions[ArgList:{{_Symbol,(_List)?OptionQ}...},Body_]:=Module[
{SymbolList,CurrentEntry,CurrentSymbol,CurrentOptionList},

SymbolList=First/@ArgList;
BlockOptions[
SymbolList,

(* set temporary values of options *)
Do[
{CurrentSymbol,CurrentOptionList}=CurrentEntry;
If[Length[CurrentOptionList]>=1,SetOptions[CurrentSymbol,Flatten[CurrentOptionList]]],
{CurrentEntry,ArgList}
];

(* evaluate body *)
Body
]
];


WithOptions[ArgList:{(_Symbol->(_List)?OptionQ)...},Body_]:=WithOptions[List@@@ArgList,Body];


WithOptions[x_Symbol,OptList_,Body_]/;MatchQ[OptList,_List?OptionQ]:=BlockOptions[
{x},
If[Length[OptList]>=1,SetOptions[x,Sequence@@Flatten[OptList]]];
Body
];


End[];


Protect[Evaluate[$Context<>"*"]];
Unprotect[Evaluate[$Context<>"$*"]];
EndPackage[];