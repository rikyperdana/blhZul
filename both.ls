<[kontrak izin limbah]>map (i) ->
	coll[i] = new Meteor.Collection i
	coll[i]allow insert: -> true

schema.kontrak = new SimpleSchema do
	nama: type: String, label: 'Nama Perusahaan'
	pelanjut: type: String, label: 'Perusahaan Pengelola Lanjut'
	jenis: type: String, label: 'Jenis Pengelolaan'
	no_kontrak: type: String, label: 'Nomor Kontrak'
	mulai: type: Date, label: 'Tanggal Kontrak'
	akhir: type: Date, label: 'Tanggal Habis Berlaku'
	lampiran: type: String
	status: type: Number, optional: true, autoform: type: \hidden

schema.izin = new SimpleSchema do
	nama: type: String, label: 'Nama Perusahaan'
	no_kep: type: String, label: 'No. Surat Keputusan'
	terbit: type: Date, label: 'Tanggal Terbit'
	habis: type: Date, label: 'Tanggal Habis Berlaku'
	jenis: type: Number, label: 'Jenis Perizinan'
	lampiran: type: String
	status: type: Number, optional: true, autoform: type: \hidden

schema.limbah = new SimpleSchema do
	nama: type: String, label: 'Nama Perusahaan'
	alamat: type: String, label: 'Alamat Perusahaan'
	no_kep: type: String, label: 'No. Surat Keputusan'
	sektor: type: String, label: 'Sektor Industri'
	kode: type: String, label: 'Kode Limbah'
	nama_limbah: type: String
	sumber: type: Number, label: 'Sumber Limbah', decimal: true
	tanggal: type: Date, label: 'Tanggal Dihasilkan'
	masa: type: Number, label: 'Masa Simpan', decimal: true
	jumlah: type: Object, label: 'Jumlah Ton'
	'jumlah.masuk': type: Number, label: 'Dihasilkan/Masuk', decimal: true
	'jumlah.lanjut': type: Number, label: 'Telah Dikelola Lanjut', decimal: true
	'jumlah.disimpan': type: Number, label: 'Disimpan TPS', decimal: true
