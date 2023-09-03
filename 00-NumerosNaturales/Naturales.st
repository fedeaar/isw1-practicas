!classDefinition: #I category: 'Naturales'!
DenotativeObject subclass: #I
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Naturales'!

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'I class' category: 'Naturales'!
I class
	instanceVariableNames: ''!

!I class methodsFor: 'operadores aritmeticos' stamp: 'FA 8/29/2023 18:20:12'!
* unNatural
	^unNatural.! !

!I class methodsFor: 'operadores aritmeticos' stamp: 'FA 8/31/2023 20:23:51'!
+ unNatural
	^unNatural next.! !

!I class methodsFor: 'operadores aritmeticos' stamp: 'fa 9/3/2023 19:19:00'!
- unNatural
	^self error: self descripcionDeErrorDeNumerosNegativosNoSoportados.! !

!I class methodsFor: 'operadores aritmeticos' stamp: 'FA 8/31/2023 20:17:27'!
/ unNatural
	unNatural = I ifFalse: [^self error: self descripcionDeErrorDeNoSePuedeDividirPorUnNumeroMayor].
	^I.! !


!I class methodsFor: 'operadores logicos' stamp: 'FA 8/29/2023 19:17:56'!
= unNatural
	^self name = unNatural name.! !

!I class methodsFor: 'operadores logicos' stamp: 'FA 8/29/2023 19:06:58'!
> unNatural
	^false.! !


!I class methodsFor: 'observadores' stamp: 'FA 8/31/2023 20:23:51'!
next
	^II.! !

!I class methodsFor: 'observadores' stamp: 'fa 9/3/2023 19:31:54'!
previous
	^self error: self descripcionDeErrorDeNumerosNegativosNoSoportados.! !


!I class methodsFor: 'error handling' stamp: 'FA 8/31/2023 20:16:22'!
descripcionDeErrorDeNoSePuedeDividirPorUnNumeroMayor
	^'No se puede dividir por un número mayor'.! !

!I class methodsFor: 'error handling' stamp: 'FA 8/29/2023 19:29:26'!
descripcionDeErrorDeNumerosNegativosNoSoportados
	^'Los numeros negativos no están soportados'.! !


!I class methodsFor: 'funciones auxiliares' stamp: 'fa 9/3/2023 19:24:11'!
divisionSinChequeoDeErrores: unNatural
	^I.! !

!I class methodsFor: 'funciones auxiliares' stamp: 'fa 9/3/2023 19:18:16'!
restaConArgsInvertidos: unNatural
	^unNatural previous.! !


!classDefinition: #II category: 'Naturales'!
DenotativeObject subclass: #II
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Naturales'!

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'II class' category: 'Naturales'!
II class
	instanceVariableNames: 'sucesor predecesor'!

!II class methodsFor: 'operadores aritmeticos' stamp: 'FA 8/31/2023 20:23:07'!
* unNatural
	^unNatural + (self previous * unNatural).
! !

!II class methodsFor: 'operadores aritmeticos' stamp: 'FA 8/31/2023 20:23:42'!
+ unNatural
	^self previous + unNatural next.
	! !

!II class methodsFor: 'operadores aritmeticos' stamp: 'fa 9/3/2023 19:17:57'!
- unNatural
	^unNatural restaConArgsInvertidos: self.
	! !

!II class methodsFor: 'operadores aritmeticos' stamp: 'fa 9/3/2023 19:23:55'!
/ unNatural
	(self < unNatural) ifTrue: [^self error: self descripcionDeErrorDeNoSePuedeDividirPorUnNumeroMayor. ].
	^self divisionSinChequeoDeErrores: unNatural.	! !


!II class methodsFor: 'operadores logicos' stamp: 'FA 8/31/2023 20:13:00'!
< unNatural
	^(self >= unNatural) not.! !

!II class methodsFor: 'operadores logicos' stamp: 'FA 8/29/2023 19:18:20'!
= unNatural
	^self name = unNatural name.
	! !

!II class methodsFor: 'operadores logicos' stamp: 'FA 8/31/2023 20:23:07'!
> unNatural
	unNatural = I ifTrue: [^true]. 	
	^self previous > unNatural previous.
	! !

!II class methodsFor: 'operadores logicos' stamp: 'FA 8/31/2023 20:09:33'!
>= unNatural
	^self = unNatural or: self > unNatural.
	! !


!II class methodsFor: 'observadores' stamp: 'FA 8/31/2023 20:23:42'!
next
	sucesor ifNotNil: [^sucesor.].
	sucesor := II createChildNamed: self name, 'I'.
	sucesor previous: self. 
	^sucesor.
	! !

!II class methodsFor: 'observadores' stamp: 'FA 8/31/2023 20:23:07'!
previous
	^predecesor.
	! !

!II class methodsFor: 'observadores' stamp: 'FA 8/31/2023 20:23:33'!
previous: numeroPredecesor
	predecesor := numeroPredecesor.
	! !


!II class methodsFor: 'funciones auxiliares' stamp: 'fa 9/3/2023 19:23:55'!
divisionSinChequeoDeErrores: unNatural
	(self >= (II * unNatural)) ifTrue: [^I + ((self - unNatural) divisionSinChequeoDeErrores: unNatural).]. 
	^I.
	! !

!II class methodsFor: 'funciones auxiliares' stamp: 'fa 9/3/2023 19:17:57'!
restaConArgsInvertidos: unNatural
	^self previous restaConArgsInvertidos: unNatural previous. 
	! !


!II class methodsFor: 'error handling' stamp: 'FA 8/29/2023 19:41:05'!
descripcionDeErrorDeNoSePuedeDividirPorUnNumeroMayor
	^'No se puede dividir por un número mayor'.! !


!II class methodsFor: '--** private fileout/in **--' stamp: 'fa 9/3/2023 19:34:01'!
initializeCollaboratorsFromFile
	"Auto generated method for loading purposes - Do not modify it"

	sucesor := III.
	predecesor := I.! !


!classDefinition: #III category: 'Naturales'!
II subclass: #III
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Naturales'!

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'III class' category: 'Naturales'!
III class
	instanceVariableNames: ''!

!III class methodsFor: '--** private fileout/in **--' stamp: 'fa 9/3/2023 19:34:01'!
initializeCollaboratorsFromFile
	"Auto generated method for loading purposes - Do not modify it"

	sucesor := IIII.
	predecesor := II.! !


!classDefinition: #IIII category: 'Naturales'!
II subclass: #IIII
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Naturales'!

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'IIII class' category: 'Naturales'!
IIII class
	instanceVariableNames: ''!

!IIII class methodsFor: '--** private fileout/in **--' stamp: 'fa 9/3/2023 19:34:01'!
initializeCollaboratorsFromFile
	"Auto generated method for loading purposes - Do not modify it"

	sucesor := AnObsoleteIIIII.
	predecesor := III.! !

II initializeAfterFileIn!
III initializeAfterFileIn!
IIII initializeAfterFileIn!