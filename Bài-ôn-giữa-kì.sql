use QLSach
go

create proc taoPBNgang
as
begin 
	select * into NhaXuatBan_TN
	from NhaXuatBan
	where LoaiHinh = N'Tư nhân'

	select * into NhaXuatBan_NN
	from NhaXuatBan
	where LoaiHinh = N'Nhà nước'
end

exec taoPBNgang

create proc taoPBNgangDanXuat
as
begin 
	select * into Sach_TN
	from Sach
	where MaNSX in (select MaNSX from NhaXuatBan_TN)

	select * into Sach_NN
	from Sach
	where MaNSX in (select MaNSX from NhaXuatBan_NN)
end

exec taoPBNgangDanXuat

create proc DSSachMuc1(@ChiNhanh nvarchar(50))
as
begin
	select s.MaSach,TenSach,nxb.MaNXB,ChiNhanh
	from NhaXuatBan nxb, Sach s
	where s.MaNSX = nxb.MaNXB and ChiNhanh = @ChiNhanh
end

create proc DSSachMuc2(@ChiNhanh nvarchar(50))
as
begin
	select s.MaSach,TenSach,nxb.MaNXB,ChiNhanh
	from NhaXuatBan_NN nxb, Sach_NN s
	where s.MaNSX = nxb.MaNXB and ChiNhanh = @ChiNhanh
end

exec DSSachMuc1 N'Hà nội'

create proc ThemMuc1 (@MaNSX nvarchar(10),@LoaiHinh nvarchar(50),@ChiNhanh nvarchar(50))
as
begin
	insert into NhaXuatBan values (@MaNSX,@LoaiHinh,@ChiNhanh)
end

exec ThemNSXTN 'HONDAVN',N'Tư nhân',N'Sài gòn'

create proc ThemMuc2 (@MaNSX nvarchar(10),@LoaiHinh nvarchar(50),@ChiNhanh nvarchar(50))
as
begin
	if @LoaiHinh = N'Nhà nước'
		insert into NhaXuatBan_NN values (@MaNSX,@LoaiHinh,@ChiNhanh)
	else
		insert into NhaXuatBan_TN values (@MaNSX,@LoaiHinh,@ChiNhanh)
end

exec ThemNSXNN 'BETAMEX',N'nhà nước',N'Sài gòn'

use QLSach
go

create proc SuaMuc1 (@MaNXB nvarchar(10),@LoaiHinh nvarchar(50),@ChiNhanh nvarchar(50))
as
begin
	update NhaXuatBan
	set LoaiHinh = @LoaiHinh,
		ChiNhanh = @ChiNhanh
	where MaNXB = @MaNXB
end



create proc SuaMuc2 (@MaNXB nvarchar(10),@LoaiHinh nvarchar(50),@ChiNhanh nvarchar(50))
as
begin
	if @LoaiHinh = N'Nhà nước'
		update NhaXuatBan_NN
		set LoaiHinh = @LoaiHinh,
			ChiNhanh = @ChiNhanh
		where MaNXB = @MaNXB
	else
	update NhaXuatBan_TN
	set LoaiHinh = @LoaiHinh,
		ChiNhanh = @ChiNhanh
	where MaNXB = @MaNXB
end

exec SuaNSXNN N'BETAMEX', N'Nhà nước', N'Hà nội'

create proc XoaMuc1 (@MaSach nvarchar(10))
as
begin
	delete Sach where MaSach = @MaSach
end

create proc XoaMuc2 (@MaSach nvarchar(10))
as
begin
	if @MaSach in (select MaSach from Sach_NN)
		delete Sach_NN where MaSach = @MaSach
	if @MaSach in (select MaSach from Sach_TN)
		delete Sach_TN where MaSach = @MaSach

end