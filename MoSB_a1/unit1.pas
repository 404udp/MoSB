unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  FileUtil, ShellApi, Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls;

type

  { TForm1 }

  TForm1 = class(TForm)
    Button1: TButton;
    Label1: TLabel;
    SelectDirectoryDialog1: TSelectDirectoryDialog;
    procedure Button1Click(Sender: TObject);
  private

  public

  end;

var
  Form1: TForm1;

implementation

{$R *.lfm}

{ TForm1 }

procedure TForm1.Button1Click(Sender: TObject);
var arh1, arh2, file_s:TStringList;
  dir1, dir2:string;
  i,i2, i3 , i4:integer;
  path_temp, path_temp2, path_temp3, path_temp4, path_out:string;
  temi2:string;
  file_ar, file_exct:string;
  str_name_file:string;
 arr_name_file:TStringArray;
begin
path_temp:='l:\temp_ship';
str_name_file:='acc.data,adam.data,boiler.data,gps.data,gpsriver.data,t.data';
arr_name_file:=str_name_file.Split(',');//получаем массив нужных файлов
path_temp2:=path_temp+'\shipBox\sent';
path_temp3:=path_temp+'\all';
path_temp4:=path_temp+'\all\shipBox\temp';
path_out:=path_temp+'\out\';
temi2:='';
CreateDir(path_temp);
CreateDir(path_temp3);
CreateDir(path_out);
//    dir1
if SelectDirectoryDialog1.Execute then
    //Listbox1.Items.Assign(SelectDirectoryDialog1.Files);
   dir1:=SelectDirectoryDialog1.FileName;
   Label1.Caption:=dir1;
//arh1:=FindAllFiles('C:\shipbox\archive\','*.rar',false);
arh1:=FindAllFiles(dir1,'*.rar',false);
try
  ShowMessage(Format('Found %d files',[arh1.Count]));
  for i:=0 to arh1.Count-1
do
begin
  Try
//    file_ar=arh1[i];
////    file_exct:='Y:\!monitoring\unpacker1\7z.exe x '+arh1[i]+' -o"'+path_temp+'" -y';
////    ExecuteProcess(file_exct, '');
  Except
    On E: EOSError Do
      WriteLn('ошибка с номером ', E.ErrorCode);
  End;
// ok ....
  arh2:=FindAllFiles(path_temp2,'*.rar',false);
  for i2:=0 to arh2.Count-1
do
begin
//ShowMessage(arh2[i2]);
//распаковsваем каждый и объединяем
file_exct:='Y:\!monitoring\unpacker1\7z.exe x '+arh2[i2]+' -o"'+path_temp3+'" -y';
ExecuteProcess(file_exct, '');
//а теперь смотрим что у нас там....
// arr_name_file список того что нужно брать
//ShowMessage(path_temp3);
file_s:=FindAllFiles(path_temp4,'*',false);
//получили список распакованніх файлов
for i3:=0 to file_s.Count-1
do
begin
//ShowMessage(file_s[i3]);
for i4:=0 to Length(arr_name_file)-1
do
begin //если находим искомый файл - объединаем его в общий
if (file_s[i3].IndexOf(arr_name_file[i4])>=0) then
   begin //copy 1.data+2.data /b 1.data
file_exct:='cmd.exe /K ';
//ExecuteProcess(file_exct, 'copy '+path_out+arr_name_file[i4]+'+'+file_s[i3]+' /b '+path_out+arr_name_file[i4]);
//if ShellExecute(0,nil, PChar('cmd'),PChar('/k copy'+path_out+arr_name_file[i4]+'+'+file_s[i3]+' /b '+path_out+arr_name_file[i4]),nil,1) =0 then;
if ShellExecute(0,nil, PChar('cmd'),PChar('/c copy '+path_out+arr_name_file[i4]+'+'+file_s[i3]+' /b '+path_out+arr_name_file[i4]),nil,0)=0 then;
Sleep(125);
//ExecuteProcess(file_exct, 'dir');
//ShowMessage(PChar(file_s[i3]));
   end
//ShowMessage(IntToStr(file_s[i3].IndexOf(arr_name_file[i4]))+file_s[i3]);
end;
end;
DeleteDirectory(path_temp3, True);

temi2:=temi2+arh2[i2];
end;
//ShowMessage(arh2[i2]);
//temi2:=temi2+arh2[i2];

//ShowMessage(arh1[i])
//распаковіваем по отдельности и добавляем в "общ файл"
end;
finally
end;
arh2.Free;
arh1.Free;
  ShowMessage(temi2)
  end;
end.

