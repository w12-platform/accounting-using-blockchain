#include <eosiolib/eosio.hpp>

using namespace eosio;
using std::string;

class w12eosbook : public eosio::contract
{

public:

	w12eosbook(account_name self):eosio::contract(self), records(_self, _self)
	{
	}


	// @abi action
	void setrecord(account_name user, const uint64_t key, const std::string& data)
	{
		auto it = records.find(key);

		if(it == records.end())
		{
			records.emplace(user, [&](auto &record)
			{
				record.key = key;
				record.owner = user;
				record.data = data;
			});
		}
		else
		{
			records.modify(it, user, [&](auto& record)
			{
				record.data = data;
			});
		}
	}


private:

	// @abi table records i64
	struct record_struct
	{
		uint64_t key;
		account_name owner = 0;
		std::string data;

		uint64_t primary_key() const {return key;}

		EOSLIB_SERIALIZE(record_struct, (key)(owner)(data))
	};

	typedef eosio::multi_index<N(records), record_struct> records_table;

	records_table records;

};



EOSIO_ABI(w12eosbook, (setrecord))

