#include <eosiolib/eosio.hpp>
#include <eosiolib/memory.hpp>
#include <eosiolib/stdlib.hpp>
#include <vector>


using namespace eosio;
using std::string;
using std::vector;

class w12eosbook : public eosio::contract
{

public:

	w12eosbook(account_name self):eosio::contract(self),
	records3(_self, _self),
	recordsdict3(_self, _self)
	{
	}


	// @abi action
	void setrecord(account_name user, const uint64_t key, const std::string& data)
	{
		auto it = recordsdict3.find(key);
		auto record_key = records3.available_primary_key();

		if(it == recordsdict3.end())
		{

			recordsdict3.emplace(user, [&](auto &item)
			{
				item.key = key;
				item.owner = user;
				item.dict.push_back(record_key);
			});
		}
		if(it != recordsdict3.end())
		{
			recordsdict3.modify(it, user, [&](auto &item)
			{
				item.dict.push_back(record_key);
			});
		}

		records3.emplace(user, [&](auto &record)
		{
			record.key = record_key;
			record.data = data;
		});


	}


private:

	// @abi table records3 i64
	struct RecordStruct
	{
		uint64_t key;
		std::string data;

		uint64_t primary_key() const {return key;}

		EOSLIB_SERIALIZE(RecordStruct, (key)(data))
	};

	typedef eosio::multi_index<N(records3), RecordStruct> RecordsTable;

	RecordsTable records3;

	// @abi table recordsdict3 i64
	struct recordsdict3
	{
		uint64_t key;
		account_name owner;
		std::vector<uint64_t> dict;
		uint64_t primary_key() const {return key;}
		EOSLIB_SERIALIZE(recordsdict3, (key)(owner)(dict))
	};

	typedef eosio::multi_index<N(recordsdict3), recordsdict3> RecordsDictTable;

	RecordsDictTable recordsdict3;



};



EOSIO_ABI(w12eosbook, (setrecord))

