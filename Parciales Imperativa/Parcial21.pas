{21) Se lee información acerca de las ventas de productos realizadas en las 5 sucursales 
de una empresa. Cada sucursal realizó a lo sumo 200 ventas. De cada venta se conoce el
código de producto, cantidad vendida y monto total de la venta. Las ventas de cada 
sucursal se leen de manera consecutiva y ordenadas por código de producto. La lectura 
por cada sucursal finaliza al completar las 200 ventas o cuando se lee el código de 
producto -1, el cual no se procesa. Implementar un programa para que a partir de la 
información leída, resuelva los siguientes ítems: 
a)Utilizando la técnica de merge o merge acumulador según corresponda, generar una 
lista que contenga la cantidad total vendida para cada código de producto, ordenada por 
código de producto. }
program Parcial21;
const
    dimF = 5;
    cant = 5;
type
    venta = record
        codigo:integer;
        cantidad:integer;
        monto:real;
    end;
    vector = array [1..dimF] of venta;
    
    regisVector = record
        v:vector;
        dimL:integer;
    end;
    vectorSucursal = array [1..cant] of regisVector;

    {A}
    nuevaVenta = record
        cantidadTotal:Real;
        codigo:integer;
    end;
    lista = ^nodo;
    nodo = record
        dato:nuevaVenta;
        sig:lista;
    end;

//___________________________________________________
procedure CargarVector(var rv:regisVector);
var
    i:integer;
begin
    for i:=1 to dimF do
    begin
        rv.v[i].codigo:=i;
        WriteLn('codigo: ',rv.v[i].codigo);

        rv.v[i].cantidad:=random(100);
        WriteLn('Cantidad: ',rv.v[i].cantidad);

        rv.v[i].monto:=random(100);
        WriteLn('monto: ',rv.v[i].monto);

        WriteLn();
        rv.dimL:=rv.dimL+1;
    end;
    WriteLn('DimL: ',rv.dimL);
end;
//___________________________________________________
procedure Cargar_Vector_Sucursal(var vs:vectorSucursal);
var
    i:Integer;
begin
    for i:=1 to cant do
    begin
        CargarVector(vs[i]);
        WriteLn('_____________');
    end;
end;    
//___________________________________________________
Procedure BorrarPos (var rv: regisVector);
var 
    i: integer; 
Begin
    if (1 <= rv.dimL) then 
    begin
        for i:= 2 to rv.dimL  do
            rv.v [ i - 1 ]  :=  rv.v [ i ] ;
        rv.dimL := rv.dimL - 1 ;         
   end;
End;
//___________________________________________________
procedure minimo(var vs:vectorSucursal; var vent:nuevaVenta);
var 
  i, pos : integer;
begin
	vent.codigo := 9999;
	pos := -1;
	for i := 1 to cant do 
		if (vs[i].v[1].codigo <= vent.codigo ) then 
		begin
			pos := i;	
			vent.codigo := vs[i].v[1].codigo;	
		end;
        
	if (pos <> -1) then
	begin
        vent.cantidadTotal:=vs[i].v[1].cantidad * vs[i].v[1].monto;
		BorrarPos(vs[pos])
	end;
end;
//___________________________________________________
procedure AgregarAlFinal2(var pri,ult:lista;x:nuevaVenta); 
var  
    nue : lista;
begin 
    new (nue);
    nue^.dato:= x;
    nue^.sig := NIL;
    if pri <> Nil then 
        ult^.sig := nue
    else 
        pri := nue;
    ult := nue;
end;
//___________________________________________________
procedure mergeAcumulador(var l :lista;vs:vectorSucursal) ;
var
	ult : lista;
	min, actual : nuevaVenta;
begin
    
	minimo(vs,min);	
    WriteLn('llego');
	while (min.codigo <> 9999) do	
	begin
		actual.cantidadTotal := 0;	
		actual.codigo := min.codigo;	
        {Este while nunca corta, solo esto falta y ya estaria (la carga de datos la hice asi unicamente para probar)}
		while (min.codigo <> 9999) and (min.codigo = actual.codigo) do begin
            WriteLn('bucle');
			actual.cantidadTotal:= actual.cantidadTotal + min.cantidadTotal;	
			minimo(vs,min);	
		end;
		AgregarAlFinal2(l,ult,actual);	
	end;
end;
//___________________________________________________
procedure ImprimirLista(l:lista);
begin
    while l <> nil do
    begin
        WriteLn('Codigo: ', l^.dato.codigo);
        WriteLn('Total: ', l^.dato.cantidadTotal);
        l:=l^.sig;    
    end;
end;
//___________________________________________________
var
    vs:vectorSucursal;
    l:lista;
begin
    randomize;
    Cargar_Vector_Sucursal(vs); {Esto esta asi nomas, porque lo importante es el punto a}
    l:=nil;
    mergeAcumulador(l,vs);
    ImprimirLista(l);
end.