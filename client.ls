if Meteor.isClient

	attr =
		kontrak:
			heads: <[nama_perusahaan perusahaan_pengelola_lanjut jenis_pengelolaan no_kontrak tanggal_kontrak tanggal_habis_berlaku lampiran status]>
		limbah:
			heads: <[nama alamat no_kep sektor kode nama_limbah sumber tanggal masa]>
		izin:
			heads: <[nama no_kep terbit habis jenis lampiran status]>
		createForm: (name, type) -> m autoForm do
			schema: schema[name], collection: coll[name], type: type,
			id: "form#name", columns: 3, hooks: after: ->
				delete state.showForm and m.redraw!
		addButton: m \.button.is-success,
			onclick: -> state.showForm = not state.showForm
			m \span, \+Tambah
		security: ->
			if Meteor.userId! then true
			else m.route.set \login and m.redraw!
		brs: (height) -> [til height]map -> m \br

	comp =
		kontrak: view: -> attr.security! and m \.container,
			m \h5.title, 'Kontrak Perusahaan'
			attr.addButton
			state.showForm and attr.createForm \kontrak, \insert
			attr.brs 3
			m \h5.title, 'Tabel Kontrak'
			m \table.table,
				oncreate: -> Meteor.subscribe \coll, \kontrak, onReady: -> m.redraw!
				m \thead, m \tr, attr.kontrak.heads.map (i) -> m \th, _.startCase i
				m \tbody, coll.kontrak.find!fetch!map (i) -> m \tr, tds [
					i.nama, i.pelanjut, i.jenis, i.no_kontrak, hari(i.mulai),
					hari(i.akhir), i.lampiran, i.status or \-]

		izin: view: -> attr.security! and m \.container,
			m \h5.title, 'Perizinan'
			attr.addButton
			state.showForm and attr.createForm \izin, \insert
			attr.brs 3
			m \h5.title, 'Tabel Perizinan'
			m \table.table,
				oncreate: -> Meteor.subscribe \coll, \izin, onReady: -> m.redraw!
				m \thead, m \tr, attr.izin.heads.map (i) -> m \th, _.startCase i
				m \tbody, coll.izin.find!fetch!map (i) -> m \tr, tds [
					i.nama, i.no_kep, hari(i.terbit), hari(i.habis),
					i.jenis, i.lampiran, i.status or \-]

		limbah: view: -> attr.security! and m \.container,
			m \h5.title, 'Jenis Limbah'
			attr.addButton
			state.showForm and attr.createForm \limbah, \insert
			attr.brs 3
			m \h5.title, 'Tabel Jenis Limbah'
			m \table.table,
				oncreate: -> Meteor.subscribe \coll, \limbah, onReady: -> m.redraw!
				m \thead, m \tr, attr.limbah.heads.map (i) -> m \th, _.startCase i
				m \tbody, coll.limbah.find!fetch!map (i) -> m \tr, tds [
					i.nama, i.alamat, i.no_kep, i.sektor, i.kode,
					i.nama_limbah, i.sumber, hari(i.tanggal), i.masa]

		login: -> view: -> m \.container, attr.brs(3), m \.columns,
			m \.column
			m \.column,
				m \.content, m \h5, \Login
				m \form,
					onsubmit: (e) ->
						e.preventDefault!
						vals = _.initial _.map e.target, -> it.value
						Meteor.loginWithPassword ...vals, (err) ->
							if err
								state.error = 'Salah Password atau Username'
								m.redraw!
							else m.route.set \/dashboard
					m \input.input, type: \text, placeholder: \Username
					m \input.input, type: \password, placeholder: \Password
					m \input.button.is-success, type: \submit, value: \Login
					if state.error then m \article.message, m \.message-header,
						(m \p, that), m \button.delete, 'aria-label': \delete
			m \.column

		register: -> view: -> m \.container, m \.content,
			attr.brs 2
			m \h5, 'Pendaftaran User Perusahaan'
			m \p, 'Persyaratan sebagai berikut'

		layout: (comp) -> view: -> m \div,
			m \nav.navbar.is-info,
				m \.navbar-brand, m \a.navbar-item, 'App Lingkungan'
				m \.navbar-end,
					Meteor.userId! and m \.navbar-item.has-dropdown,
						class: \is-active if state.linkMenu
						m \a.navbar-link,
							onclick: -> state.linkMenu = not state.linkMenu
							m \span, \Menu
						m \.navbar-dropdown.is-right, <[kontrak izin limbah]>map (i) ->
							m \a.navbar-item,
								onclick: -> m.route.set "/#i" and m.redraw!
								m \span, _.startCase i
					m \.navbar-item.has-dropdown,
						class: \is-active if state.userMenu
						m \a.navbar-link,
							onclick: -> state.userMenu = not state.userMenu
							m \span, (Meteor.user!?username or \User)
						m \.navbar-dropdown.is-right, do ->
							arr =
								if Meteor.userId! then [[\Logout, -> Meteor.logout! and m.redraw!]]
								else arr =
									[\Login, -> m.route.set \login and m.redraw!]
									[\Register, -> m.route.set \register and m.redraw!]
							arr.map (i) -> m \a.navbar-item, onclick: i?1, i?0
			m \.columns,
				m \.column, if comp then m that

	m.route.prefix ''
	m.route document.body, \/login,
		'/kontrak': comp.layout comp.kontrak
		'/izin': comp.layout comp.izin
		'/limbah': comp.layout comp.limbah
		'/login': comp.layout comp.login
		'/register': comp.layout comp.register
