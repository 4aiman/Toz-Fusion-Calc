unit main;

{$mode objfpc}{$H+}

interface

uses
  Windows, Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls,
  ActnList, LResources, ExtCtrls, Grids, ComCtrls, Types;

type

  { TForm1 }

  TForm1 = class(TForm)
    Bevel1: TBevel;
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
    Image2: TImage;
    Image3: TImage;
    Image4: TImage;
    Image5: TImage;
    Image6: TImage;
    Image7: TImage;
    ImageList1: TImageList;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    hintl: TLabel;
    procedure ComboBox1Change(Sender: TObject);
    procedure ComboBox1DrawItem(Control: TWinControl; Index: Integer;
      ARect: TRect; State: TOwnerDrawState);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure Image6MouseLeave(Sender: TObject);
    procedure Image6MouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer
      );
    procedure Image6MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Image6Paint(Sender: TObject);
    procedure Image7Paint(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure UpdateForm();
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
    m: array [0..3] of TImage;
    g: array [0..49] of integer;
   g2: array [0..49] of integer;
   re: array [0..3] of integer;


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
function TForm1.NewElement(edit: TEdit): string;
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
          re[r-1] := id3-1;
          text :=  '     '+item3;
          s[r-1] :=item3;


          m[r-1].Parent:=edit;
          m[r-1].Canvas.Clear;
          Imagelist1.Draw(m[r-1].Canvas, 2, 2, id3);
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
   UpdateForm();
end;

procedure TForm1.ComboBox1DrawItem(Control: TWinControl; Index: Integer;
  ARect: TRect; State: TOwnerDrawState);
begin//
     with Control as TComboBox do
          if index > 0 then begin
             Canvas.FillRect(Arect);
             Imagelist1.Draw(Canvas, aRect.Left+2, aRect.Top+2, Index );
             Canvas.TextOut(ARect.Left+30, ARect.Top+2, Items[Index]);
          end;
end;

procedure TForm1.FormCreate(Sender: TObject);
var _:integer;
begin
  for _ := 0 to 3 do begin
      i[0,_] := 0;
      i[1,_] := 0;
      p[_] := 0;
      re[_]:=0;
  end;
  s1:='';
  s2:='';

  for _ := 0 to 49 do begin
      g[_]:=0;
     g2[_]:=0;
  end;

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

       m[0]:=Image2;
       m[1]:=Image3;
       m[2]:=Image4;
       m[3]:=Image5;

       m[0].Canvas.Clear;
       m[1].Canvas.Clear;
       m[2].Canvas.Clear;
       m[3].Canvas.Clear;

  end;
    Image6.Canvas.Clear;
    Image7.Canvas.Clear;
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

procedure TForm1.Image6MouseLeave(Sender: TObject);
begin
     hintl.Visible:=false;
end;

procedure TForm1.Image6MouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
      hintl.Caption:=c[0].items[(x div 40)*5+(y div 40)+1];
      hintl.Left:=(sender as TControl).Left + X+20;
      hintl.Top:=(sender as TControl).Top +Y+1;
      hintl.Visible:=true;
end;

procedure TForm1.Image6MouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var idx, j, n:integer;
begin
     idx:= (x div 40)*5+(y div 40);
     if button = mbLeft then g[idx] := g[idx] + 1;
     if button = mbRight then g[idx] := g[idx] - 1;
     if g[idx] <0 then g[idx]:=0;

     UpdateForm();

end;

procedure TForm1.Image6Paint(Sender: TObject);
var index:integer;
begin
     with (sender as TImage) do begin
     Canvas.Brush.Color:=$00202125;
     Canvas.Clear;
     Canvas.Pen.Color:=clCream;
     Canvas.Font.Color:=clCream;
     Canvas.Font.Size:=10;
     for index:=1 to 50 do begin
         if g[index-1] = 0 then
            begin
               if (index<41) then
                  imagelist1.StretchDraw(canvas, (((index-1) div 5)+1)+50, Rect(40*(((index-1) div 5)), 40*(((index-1) mod 5)), 40*(((index-1) div 5))+38, 40*(((index-1) mod 5))+38));

               if (index>40) and (index < 46) then
                  imagelist1.StretchDraw(canvas, (((index-1) div 5)+1+(index-1) mod 5)+50, Rect(40*(((index-1) div 5)), 40*(((index-1) mod 5)), 40*(((index-1) div 5))+38, 40*(((index-1) mod 5))+38));

               if (index > 45) then
                  imagelist1.StretchDraw(canvas, (((index-1) div 5)+5)+50, Rect(40*(((index-1) div 5)), 40*(((index-1) mod 5)), 40*(((index-1) div 5))+38, 40*(((index-1) mod 5))+38));
            end
         else begin
            imagelist1.StretchDraw(canvas, index, Rect(40*(((index-1) div 5)), 40*(((index-1) mod 5)), 40*(((index-1) div 5))+38, 40*(((index-1) mod 5))+38));
            canvas.textout(40*(((index-1) div 5))+30, 40*(((index-1) mod 5))+22, inttostr(g[index-1]));
         end;

         //canvas.textout(40*(((index-1) div 5)), 40*(((index-1) mod 5)),c[0].Items[index-1]);
     end;


     end;

end;

procedure TForm1.Image7Paint(Sender: TObject);
var index:integer;
begin
  image7.Canvas.Brush.Color:=$00202125;
  Image7.Canvas.Clear;
  Image7.Canvas.Pen.Color:=clCream;
  Image7.Canvas.Font.Color:=clCream;
  for index:=1 to 50 do begin
      if g2[index-1] = 0 then begin
            if (index<41) then
               imagelist1.StretchDraw(image7.canvas, (((index-1) div 5)+1)+50, Rect(40*(((index-1) div 5)), 40*(((index-1) mod 5)), 40*(((index-1) div 5))+38, 40*(((index-1) mod 5))+38));

            if (index>40) and (index < 46) then
               imagelist1.StretchDraw(image7.canvas, (((index-1) div 5)+1+(index-1) mod 5)+50, Rect(40*(((index-1) div 5)), 40*(((index-1) mod 5)), 40*(((index-1) div 5))+38, 40*(((index-1) mod 5))+38));

            if (index > 45) then
               imagelist1.StretchDraw(image7.canvas, (((index-1) div 5)+5)+50, Rect(40*(((index-1) div 5)), 40*(((index-1) mod 5)), 40*(((index-1) div 5))+38, 40*(((index-1) mod 5))+38));
      end
      else begin
         imagelist1.StretchDraw(image7.canvas, index, Rect(40*(((index-1) div 5)), 40*(((index-1) mod 5)), 40*(((index-1) div 5))+38, 40*(((index-1) mod 5))+38));
         image7.canvas.textout(40*(((index-1) div 5))+30, 40*(((index-1) mod 5))+22, inttostr(g2[index-1]));
      end;
  end;
end;

procedure TForm1.Timer1Timer(Sender: TObject);
begin
     image6.Invalidate;
     image7.Invalidate;
end;

procedure TForm1.UpdateForm();
var j,n:integer;
begin//
  for j:=0 to 49 do g2[j] := g[j];
//  showmessage('f');
  for n:=0 to 3 do begin
      if (c[n].itemindex>0) and (c[n+4].itemindex>0) then begin
         for j:=0 to 49 do begin
             if (g[j]>0) and (c[n].itemindex-1 = j) then begin
                 g2[j]:=g2[j]-1;
                 if g2[j]<0 then g2[j]:=0;
                 g2[re[n]]:=g2[re[n]]+1;
             end;
         end;
      end
  end;
  Image6.Invalidate;
  Image7.Invalidate;
end;

end.

