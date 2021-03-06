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



(* :Title: StyleOptions *)
(* :Context: StyleOptions` *)
(* :Author: Mark A. Caprio, Department of Physics, University of Notre Dame *)
(* :Summary: Styles with inheritance. *)
(* :Copyright: Copyright 2014, Mark A. Caprio *)
(* :Package Version: 0.99 *)
(* :Mathematica Version: 6.0 *)
(* :History:
Based on code from SciDraw beta, January 3, 2012.
December 20, 2013. Add ShowStyles[].
January 30, 2014. Add ClearStyles[].
 *)


BeginPackage["StyleOptions`"];


Unprotect[Evaluate[$Context<>"*"]];


StyleOptions::usage="StyleOptions[style] returns the options associated with style, for all symbols, as a list of rules of the form {symbol1\[Rule]options1,...}.  StyleOptions[style,symbol] retrieves those options associated specifically with the given symbol.";
StyleQ::usage="StyleQ[style] returns True if and only if the expression style resolves to a valid style name.";
WithStyle::usage="WithStyle[style,body] or WithStyle[{style1,...},body] evaluates body with the default options set according to the given style or styles.  This is accomplished using WithOptions.";
StyleSpecifierPattern::usage="StyleSpecifierPattern is a pattern which matches None, a style name, or a list of style names and symbol->options rules, as appropriate to the argument of StyleOptions or WithStyle.";


DefineStyle::usage="DefineStyle[style,expr] defines a new style, where the style name may itself involve named patterns, which serve as arguments to expr.  The expression expr should evaluate to a list of the form  {symbol1->options1,symbol2->options2,...}, where other (parent) style names may be interspersed, e.g., {symbol1->options1,symbol2->options2,...,parent1,parent2}.";
ShowStyles::usage="ShowStyles[] displays all current style definitions.  This is meant for diagnostic purposes.";
ClearStyles::usage="ClearStyles[] clears all current style definitions.  This is meant for diagnostic purposes.";


Begin["`Private`"];


Needs["BlockOptions`"];
Needs["InheritOptions`"];  (* for OptionsUnion[] *)


General::argsexpr="Missing or unexpected arguments in `1`.";
General::argsnull="One of the arguments in `1` is Null.  Check for extra commas among the arguments.";


ThrowMessage[f_Symbol,m_String,Args___]:=Message[MessageName[f,m],Args];


SetAttributes[FallThroughError,HoldRest];
FallThroughError[Self_Symbol,Expr_]:=Module[
{},
If[
Count[Hold[Expr],Null,{2}]>0,
ThrowMessage[Self,"argsnull",HoldForm[Expr]],
ThrowMessage[Self,"argsexpr",HoldForm[Expr]]
];
$Failed
];


DeclareFallThroughError[f_Symbol]:=(Expr:HoldPattern[f[___]]:=FallThroughError[f,Expr]);


SetAttributes[DefineStyle,{HoldRest}];


DefineStyle[Name_,Function_]:=Module[
{},
StyleDefinitionFlag[Name]=True;
StyleDefinition[Name]:=Function;
];
DeclareFallThroughError[DefineStyle];


StyleListPattern={(None|(_?StyleQ)|Rule[_Symbol,_List])...};  (* quick check for argument matching *)
ValidatedStyleListPattern={(None|(_?StyleQ)|Rule[_Symbol,{Rule[(_Symbol)|(_String),_]...}])...};  (* detailed check for validation *)
StyleSpecifierPattern=None|(_?StyleQ)|StyleListPattern


StyleQ[Name_]:=TrueQ[StyleDefinitionFlag[Name]];


MergeStyleOptions[RawStyleOptions_List]:=Module[
{ReversedStyleOptions},

(* reverse order, so latter styles have priority over earlier styles in final combined rule list *)
ReversedStyleOptions=Reverse[RawStyleOptions];

(* merge multiple specifications for same symbol *)
(* CAVEAT: See notes in InheritOptions.nb on ordering issues in use of Sort. *)
Cases[
SplitBy[Sort[ReversedStyleOptions,OrderedQ[{First[#1],First[#2]}]&],First],
(rseq:{(s_Symbol->_List)..}):>(s->OptionsUnion[Last/@rseq])
]
];


StyleOptions::undef="Style `1` has not been defined.";
StyleOptions::stylebadvalue="Style `1` has been resolved to an invalid expression `2`.  The result should be a list containing entries each of which must either be a rule of the form symbol1->options1 or correspond to a known style name.  (Note: A common error is to just give a single rule of the form symbol1->options1, not to wrap it in a list as {symbol1->options1}.)";
StyleOptions::listbadvalue="The given list `1` does not contain entries of the form symbol1->options1 or corresponding to known style names.";


StyleOptions[Name:None]={};


StyleOptions[Name_?StyleQ]:=Module[
{StyleList},

(* evaluate options list*)
StyleList=StyleDefinition[Name];

(* validate options list so far *)
(* it is good to do this now, while we still remember the style name and can give it in the error message *)
If[
!MatchQ[StyleList,ValidatedStyleListPattern],
Message[StyleOptions::stylebadvalue,Name,StyleList];
Return[{}]
];

(* recursively resolve options list *)
StyleOptions[StyleList]

];


StyleOptions[StyleList:StyleListPattern]:=Module[
{SplicedStyleList},

(* validate options list so far *)
If[
!MatchQ[StyleList,ValidatedStyleListPattern],
Message[StyleOptions::listbadvalue,StyleList];
Return[{}]
];

(* recursively resolve and flatten *)
SplicedStyleList=Flatten[Cases[StyleList,x_:>Switch[x,_Rule,x,_,StyleOptions[x]]]];

(* merge duplicate definitions *)
MergeStyleOptions[SplicedStyleList]

];


StyleOptions[StyleSpecifier:StyleSpecifierPattern,s_Symbol]:=Replace[s,Append[StyleOptions[StyleSpecifier],(_->{})]];


StyleOptions[Junk:Except[StyleListPattern],s:_Symbol:None]:=Module[
{},
ThrowMessage[StyleOptions,"undef",Junk];
$Failed
];


DeclareFallThroughError[StyleOptions];


SetAttributes[WithStyle,HoldRest];


WithStyle[StyleSpecifier:StyleSpecifierPattern,Body_]:=Module[
{},

(* apply options and evaluate body *)
WithOptions[
StyleOptions[StyleSpecifier],
Body
]

];
DeclareFallThroughError[WithStyle];


ShowStyles[]:=Module[
{},

Definition[StyleDefinition]

];
DeclareFallThroughError[ShowStyles];


ClearStyles[]:=Module[
{},

Clear[StyleDefinition]

];
DeclareFallThroughError[ClearStyles];


End[];


Protect[Evaluate[$Context<>"*"]];
EndPackage[];
