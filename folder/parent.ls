if Meteor.isClient
	@coll = {}
	@state = {}
	@tds = -> it.map (i) -> m \td, i
	@hari = -> moment it .format 'D MMM YYYY'
