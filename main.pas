unit main;

{$mode objfpc}{$H+}

interface

uses
  Windows, Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls,
  ActnList, LResources, ExtCtrls;

type

  { TForm1 }

  TForm1 = class(TForm)
    ComboBox1: TComboBox;
    ComboBox2: TComboBox;
    ComboBox3: TComboBox;
    ComboBox4: TComboBox;
    ComboBox5: TComboBox;
    ComboBox6: TComboBox;
    ComboBox7: TComboBox;
    ComboBox8: TComboBox;
    Edit1: TEdit;
    Edit2: TEdit;
    Edit3: TEdit;
    Edit4: TEdit;
    Image1: TImage;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    procedure ComboBox1Change(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    function NewElement(edit:TEdit): string;

  public

  end;

var
  Form1: TForm1;

implementation
{$R *.frm}
{$R font.res}

var i:array[0..1, 0..3] of integer; s1, s2, s3:string;
    p: array [0..3] of integer;
    e: array [0..4] of string = ('Normal', 'Fire', 'Earth', 'Water', 'Wind');
    a: array [0..9] of string = ('Status', 'Abilities', 'HP', 'SC', 'BG', 'S.Change', 'Cat 1', 'Cat 2', 'Elemental', 'Incantation');
    c: array [0..7] of TCombobox;
    d: array [0..3] of TEdit;
    s: array [0..3] of string;


const
    MM_MAX_NUMAXES = 16;
type
  PDesignVector = ^TDesignVector;
  TDesignVector = packed record
    dvReserved: DWORD;
    dvNumAxes: DWORD;
    dvValues: array[0..MM_MAX_NUMAXES-1] of Longint;
  end;

 function AddFontMemResourceEx(p1: Pointer; p2: DWORD; p3: PDesignVector; p4: LPDWORD): THandle; stdcall external 'gdi32.dll' name 'AddFontMemResourceEx';
 function RemoveFontMemResourceEx(p1: THandle): BOOL; stdcall external 'gdi32.dll' name 'RemoveFontMemResourceEx';

 function LoadFontFromRes(FontName: PChar):THandle;
 var
   ResHandle: HRSRC;
   ResSize, NbFontAdded: Cardinal;
   ResAddr: HGLOBAL;
 begin
   ResHandle := FindResource(system.HINSTANCE, FontName, RT_RCDATA);
   if ResHandle = 0 then
     RaiseLastOSError;
   ResAddr := LoadResource(system.HINSTANCE, ResHandle);
   if ResAddr = 0 then
     RaiseLastOSError;
   ResSize := SizeOfResource(system.HINSTANCE, ResHandle);
   if ResSize = 0 then
     RaiseLastOSError;
   Result := AddFontMemResourceEx(Pointer(ResAddr), ResSize, nil, @NbFontAdded);
   if Result = 0 then
     RaiseLastOSError;
 end;

{ TForm1 }
function Tform1.NewElement(edit:TEdit): string;
var t, r:integer;   id1,id2,col1,col2,row1,row2,id3,col3,row3, type_:integer; item1, item2, item3:string;
begin//
     with edit do begin
          t:=tag+1;
          if t div 4 > 0 then r:=4
          else if t div 3 > 0 then r:=3
          else if t div 2 > 0 then r:=2
          else if t div 1 > 0 then r:=1;

          id1 := c[r-1].itemindex; // r=1, id1=0, id2=4; 2 1 5; 3 2 6; 4 3 7;
          id2 := c[r+3].itemindex;

          item1 := ComboBox1.Items[id1];
          item2 := ComboBox1.Items[id2];
          col1 := (id1-1) div 5;
          row1 := ((id1-1) mod 5)+1;
          col2 := (id2-1) div 5;
          row2 := ((id2-1) mod 5)+1;

          // different elements and columns
           if (col1 <> col2) and (row1 <> row2) then begin
               id3:=(id1+id2) div 2;
               while (id3=id1) or (id3=id2) do id3 := id3+1;
               col3 := (id3-1) div 5;
               row3 := ((id3-1) mod 5)+1;
               type_:=1;
           end
           else if (col1 <> col2) and (row1 = row2) then begin
                   col3 := (col1+col2) div 2;
                   row3 := row1;
                   while (col3=col1) or (col3=col2) do begin
                          col3 := col3+1;
                          if col3>9 then col3 := 0;
                   end;
                   id3:=col3*5+row3;
                   type_:=2;
                end
                else if (col1 = col2) and (row1 <> row2) then begin
                     col3 := col1;
                     row3:= (row1+row2)-1;
                     if row3>5 then row3 :=row3-5;
                     while (row3=row1) or (row3=row2) do
                            begin
                                 row3:=row3+1;
                                 if row3>5 then row3 :=row3-5;
                            end;
                     id3:=col3*5+row3;
                     type_:=3;
                end
                else begin
                     id3 := id1;
                     col3:= col1;
                     row3:=row1;
                     type_:=0;
                end;

          item3 := ComboBox1.Items[id3];
          text := item3;
          s[r-1] := item3;
     end;
end;

procedure TForm1.ComboBox1Change(Sender: TObject);
var id: integer = 0;
    item, col, row:integer;
begin    //
   with (sender as TComboBox) do begin
        if itemindex<0 then exit;
        if tag>3
           then
              id:=tag-4
           else
              id:=tag;

        i[tag div 4, id] := ItemIndex;
        NewElement(d[id]);
end;



end;

procedure TForm1.FormCreate(Sender: TObject);
var _:integer;
begin
  for _ := 0 to 3 do begin
      i[0,_] := 0;
      i[1,_] := 0;
      p[_] := 0;
  end;
  s1:='';
  s2:='';

  with sender as TForm1 do begin
       c[0]:=Combobox1;
       c[1]:=Combobox2;
       c[2]:=Combobox3;
       c[3]:=Combobox4;
       c[4]:=Combobox5;
       c[5]:=Combobox6;
       c[6]:=Combobox7;
       c[7]:=Combobox8;

       d[0]:=Edit1;
       d[1]:=Edit2;
       d[2]:=Edit3;
       d[3]:=Edit4;
  end;

end;

procedure TForm1.FormShow(Sender: TObject);
var
  vFnt : THandle;
  i:integer;
begin
    vFnt := LoadFontFromRes('seagullregular');
    SendMessage(Handle, WM_FONTCHANGE, 0, 0);
    Application.ProcessMessages;
    Font.Name:='SEAGULL REGULAR';
    for i:=0 to 7 do c[i].font.name:=Font.Name;
    for i:=0 to 3 do d[i].font.name:=Font.Name;
    Image1.BringToFront;

end;

end.

