% Se tienen los siguientes functores:
% perro(tamaño)
% gato(sexo, cantidad de personas que lo acariciaron)
% tortuga(carácter)

mascota(pepa, perro(mediano)).
mascota(frida, perro(grande)).
mascota(piru, gato(macho,15)).
mascota(kali, gato(hembra,3)).
mascota(olivia, gato(hembra,16)).
mascota(mambo, gato(macho,2)).
mascota(abril, gato(hembra,11)).
mascota(buenaventura, tortuga(agresiva)).
mascota(severino, tortuga(agresiva)).
mascota(simon, tortuga(tranquila)).
mascota(quinchin, gato(macho,0)).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Punto 1
tiene(martin,pepa,2014,adopcion).
tiene(martin,frida,2015,adopcion).
tiene(martin,kali,2016,adopcion).
tiene(martin,olivia,2014,adopcion).
tiene(constanza,abril,2006,regalo).
tiene(constanza,mambo,2015,adopcion).
tiene(hector,abril,2015,adopcion).
tiene(hector,mambo,2015,adopcion).
tiene(hector,buenaventura,1971,adopcion).
tiene(hector,severino,2007,adopcion).
tiene(hector,simon,2016,adopcion).
tiene(martin,piru,2010,compra).
tiene(hector,abril,2006,compra).
tiene(silvio,quinchin,1990,regalo).

% comprometidos/2 se cumple para dos personas cuando adoptaron el mismo año a la misma mascota.
comprometidos(Alguien,Otro):-
   tiene(Alguien,Mascota,Anio,adopcion),
   tiene(Otro,Mascota,Anio,adopcion).

% locoDeLosGatos/1 se cumple para una persona cuando tiene sólo gatos, pero más de uno.

locoDeLosGatos(Persona):-
   tieneMasDe1Mascota(Persona),
   forall(tiene(Persona,Mascota,_,_), esGato(Mascota)).

tieneMasDe1Mascota(Persona):-
   tiene(Persona,Mascota,_,_),
   tiene(Persona,Mascota2,_,_),
   Mascota \= Mascota2.

esGato(Mascota):-
   mascota(Mascota,gato(_,_)).

% puedeDormir/1 Se cumple para una persona si no tiene mascotas que estén chapita (los perros chicos, las tortugas y los gatos macho que fueron acariciados menos de 10 veces están chapita). 
% Debe ser inversible.

puedeDormir(Persona):-
   persona(Persona),
   not((tiene(Persona,Mascota,_,_),estaChapita(Mascota))).

persona(Persona):-
    tiene(Persona,_,_,_).

estaChapita(Mascota):-
   mascota(Mascota,Especie),
   especieChapita(Especie).

especieChapita(perro(chico)).
especieChapita(tortuga(_)).
especieChapita(gato(macho,VecesAcariciado)):-
   VecesAcariciado < 10.



% crisisNerviosa/2 es cierto para una persona y un año cuando el año anterior adoptó o compró una mascota que está chapita y ya antes tenía otra mascota que está chapita. (los perros chicos, las tortugas y los gatos que fueron acariciados menos de 10 veces están chapita)

crisisNerviosa(Persona,Anio):-
    AnioAnterior is Anio - 1,
    tiene(Persona,MascotaChapita,AnioAnterior,_),
    estaChapita(MascotaChapita),
    tiene(Persona,OtraM,OtroAnio,_),
    estaChapita(OtraM),
    OtroAnio < AnioAnterior.

% b) No es inversible por el segundo argumento. Anio debe llegar ligada al is para que el is pueda resolver la cuenta, por lo tanto si Anio es variable, el is no funciona. Una forma de hacerlo inversible es plantearlo como una suma, poniendo el tiene primero:
% tiene(Persona,MascotaChapita,AnioAnterior,_),
% Anio is AnioAnterior + 1,
% ....


% mascotaAlfa/2 Relaciona una persona con el nombre de una mascota, cuando esa mascota domina al resto de las mascotas de esa persona. Se sabe que un gato siempre domina a un perro, que un perro grande domina a uno chico, que un gato chapita domina a gatos no chapita, y que una tortuga agresiva domina cualquier cosa. 

mascotaAlfa(Persona,Alfa):-
   tiene(Persona,Alfa,_,_),
   forall((tiene(Persona,Otra,_,_), Otra \= Alfa), dominaA(Alfa,Otra)).

dominaA(Dominante,Dominado):-
   mascota(Dominante,EspecieDominante),
   mascota(Dominado,EspecieDominado),
   domina(EspecieDominante,EspecieDominado).

domina(gato(_,_),perro(_)).
domina(perro(grande),perro(chico)).
domina(gato(Sexo,CVA),gato(Sexo2,CVA2)):-
   especieChapita(gato(Sexo,CVA)),
   not(especieChapita(gato(Sexo2,CVA2))).
domina(tortuga(agresiva),_).

% materialista/1 se cumple para una persona cuando no tiene mascotas o compró más de las que adoptó ó regaló. Hacer que sea inversible. 


% Para que sea inversible hay que agregar cláusulas al predicado persona, con las personas que existen pero no tienen animales.
% por ejemplo, persona(juancho), persona(gime).

materialista(Alguien):-
    persona(Alguien),
    not(tiene(Alguien,_,_,_)).
materialista(Alguien):- 
    cantidad(Alguien,compra,CantCompra),
    cantidad(Alguien,adopcion,CantAdopcion),
    CantCompra > CantAdopcion.

cantidad(Alguien,Que,Cant):-
    persona(Alguien),
    findall(Nombre, tiene(Alguien,Nombre,Que,_), Nombres),
    length(Nombres,Cant).
