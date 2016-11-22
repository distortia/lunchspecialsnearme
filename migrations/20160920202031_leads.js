
exports.up = function(knex, Promise) {
	return Promise.all([
		knex.schema.createTable('leads', function(table){
			table.increments('id').primary();
			table.string('email').unique();
			table.timestamps();
		})
	])
  
};

exports.down = function(knex, Promise) {
  	return Promise.all([
		knex.schema.dropTable('leads')
  	])
};
