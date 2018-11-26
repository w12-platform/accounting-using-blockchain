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
	records11(_self, _self),
	dict11(_self, _self)
	{
	}


	// @abi action
	void setrecord(account_name user, const uint64_t key, const std::string& data)
	{
		auto it = dict11.find(key);
		auto record_key = records11.available_primary_key();

		if(it == dict11.end())
		{

			dict11.emplace(user, [&](auto &item)
			{
				item.key = key;
				item.owner = user;
				item.dict.push_back(record_key);
			});
		}
		if(it != dict11.end())
		{
			dict11.modify(it, user, [&](auto &item)
			{
				item.dict.push_back(record_key);
			});
		}

		records11.emplace(user, [&](auto &record)
		{
			record.key = record_key;
			record.data = data;
		});
	}

private:

	// @abi table records11 i64
	struct RecordStruct
	{
		uint64_t key;
		std::string data;

		uint64_t primary_key() const {return key;}

		EOSLIB_SERIALIZE(RecordStruct, (key)(data))
	};

	typedef eosio::multi_index<N(records11), RecordStruct> RecordsTable;

	RecordsTable records11;

	// @abi table dict11 i64
	struct dict11
	{
		uint64_t key;
		account_name owner;
		std::vector<uint64_t> dict;
		uint64_t primary_key() const {return key;}
		EOSLIB_SERIALIZE(dict11, (key)(owner)(dict))
	};

	typedef eosio::multi_index<N(dict11), dict11> RecordsDictTable;

	RecordsDictTable dict11;
};


EOSIO_ABI(w12eosbook, (setrecord))


//private:
//
//// @abi table records11 i64
//struct RecordStruct
//{
//	uint64_t key;
//	uint64_t user_id;
//	uint64_t history_id;
//
//	uint64_t history_len;
//	std::string data;
//
//	uint64_t primary_key() const {return key;}
//	uint64_t get_user_id() const {return user_id;}
//	uint64_t get_history_id() const {return history_id;}
//
//	EOSLIB_SERIALIZE(RecordStruct, (key)(user_id)(history_id)(history_len)(data))
//};
//
//
//
//typedef multi_index<N(RecordStruct), RecordStruct,
//		indexed_by<N(user_id), const_mem_fun<RecordStruct, uint64_t, &RecordStruct::get_user_id>>,
//indexed_by<N(history_id), const_mem_fun<RecordStruct, uint64_t, &RecordStruct::get_history_id>>
//> Records;
//
//
//Records records11;
//};


