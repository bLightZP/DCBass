@echo off

cd Source
del *.~*;*.dcu;*.obj;*.hpp;*.ddp

cd Interface
del *.~*;*.dcu;*.obj;*.hpp;*.ddp

cd ..\PropertyPages
del *.~*;*.dcu;*.obj;*.hpp;*.ddp

cd Zlib
del *.~*;*.dcu

cd ..\..\..\Binary