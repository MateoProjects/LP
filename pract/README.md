# Practica LP

## Descripció 

En aquesta pràctica s'ha implementat un algorisme de decisions. Donat el dataset agaricus-lepiota.data l'algorisme és capaç de predir de quin tipus seran els bolets, si verinosos o comestibles. 

## Continguts 

* **dts.hs** : Conté el codi font de la pràctica. Cada funció conté una descripció de la seva capçalera i el que retorna. 

* **test.txt** : Dataset que és un petit fragment del dataset original. Dataset per comprovar les funcions inicials que permeten parsejar el dataset i preparar-lo. 

* **test2.txt** : Dataset basat en el dataset que es troba en el següent [link](https://gebakx.github.io/ml/#36) . Dataset que permet comprovar la generació de l'arbre i funcions com el càlcul del amb un Dataset més petit. 

* **agaricus-lepiota.data** : Dataset a emprar per la generació de l'arbre. 

* **agaricus-peiota.names** : Conté el significat de cada columna i els possibles valors que pot prendre. 

## Pre Requisit

*   Tenir instalat l'interpret de haskell. En cas de no tenir-lo instalat es pot seguir la següent guia per [windows](https://downloads.haskell.org/~ghc/6.2/docs/html/users_guide/sec-install-windows.html) o aquesta per [linux](https://www.haskell.org/platform/linux.html)

## Instal·lació 

* Descomprimir la carpeta.

## Mètode d'ús

1. Obrir un terminal i dirigir-nos a la nostre carpeta on es trobi el codi font (dts.hs)
2. executar la comanda **ghci dts.hs**
3. L'algorisma es quedarà uns instants bloquejats, ja que estarà generant l'arbre. Posteriorment s'iniciarà una sèrie de preguntes on s'anirà preguntant per atributs. Finalment ens indicarà si es tracta d'un bolet comestible o verinos. 

**Nota**: per canviar el dataset i emprar un altre de mushrooms amb diferents columnes cal modificar la primera línia del codi de la funció **main** . Canviar el nom del fitxer pel nou. 
