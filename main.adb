with Ada.Text_IO; use Ada.Text_IO;

-- Item\tQuantity\tPrice\tTaxable[\tTax]

procedure Main is
	type Money_Type is delta 0.01 range -1_000_000_000.0 .. 1_000_000_000.0;
	for Money_Type'Small use 0.0001;

	subtype Tax_Type is Money_Type range 0.0 .. 1.0;

	subtype Quantity_Type is Integer range 0..1000;
	subtype Buffer_Length is Integer range 1..256;

	subtype Input_String is String(Buffer_Length'First..Buffer_Length'Last);

	package Fixed_IO is new Ada.Text_IO.Fixed_IO(Money_Type);
	package Integer_IO is new Ada.Text_IO.Integer_IO(Integer);

	Sub_Total : Money_Type := 0.0;
	Total : Money_Type;
	Taxable_Total : Money_Type := 0.0;

begin
	Set_Line_Length(To => Count'Val(Buffer_Length'Last));
	loop
		declare
			Item_Name : Input_String;
			Item_Name_Length : Buffer_Length;

			Item_Quantity : Quantity_Type;

			Item_Price : Money_Type;

			Item_Taxable_Input : Character;
			--Item_Taxable_Length : Buffer_Length;
			Item_Taxable : Boolean;
			--Item_Tax : Tax_Type;

		begin
		Put("Item name: ");
		Get_Line(Item_Name, Item_Name_Length);
		if Item_Name_Length = Buffer_Length'Last then
			Put_Line("Item name is too long.  Limit is " & Integer'Image(Buffer_Length'Last-1) & " characters.");
			raise Data_Error;
		end if;
		Put_Line("Item name set to " & Item_Name(Input_String'First..Item_Name_Length));
		Put_Line("");

		Put("Item quantity: ");
		Integer_IO.Get(Item_Quantity);
		Put_Line("Item quantity set to " & Integer'Image(Item_Quantity));
		Put_Line("");
		Skip_Line;

		Put("Item price: ");
		Fixed_IO.Get(Item_Price);
		Put_Line("Item price set to " & Money_Type'Image(Item_Price));
		Put_Line("");
		Skip_Line;

		Put("Item taxable (y/n): ");
		Get(Item_Taxable_Input);
		Item_Taxable := Item_Taxable_Input = 'y';
		Put_Line("Item taxability set to " & Boolean'Image(Item_Taxable));
		Put_Line("");
		Skip_Line;

		if Item_Taxable then
			Taxable_Total := Taxable_Total + Item_Price;
		end if;
		Sub_Total := Sub_Total + Item_Price;
		exception
			-- EOF is End_Error.
			when End_Error => exit;
			-- If invalid input, we'll retry.
			when Data_Error =>
				Put_Line("");
				Put_Line("***ERROR: Please try again.");
				Skip_Line;
		end;
	end loop;
	Put_Line("Transaction:");
	Total := Taxable_Total*0.07125 + Sub_Total;
	Put_Line("Subtotal: " & Money_Type'Image(Sub_Total));
	Put_Line("Taxable total: " & Money_Type'Image(Taxable_Total));
	Put_Line("Total: " & Money_Type'Image(Total));
end Main;
