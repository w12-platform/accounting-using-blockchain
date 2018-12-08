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
	records11e(_self, _self)
	{
	}


	// @abi action
	void setrecord(account_name user, const uint64_t key, const std::string& data)
	{
		auto it = records11e.find(key);

		if(it == records11e.end())
		{

			records11e.emplace(user, [&](auto &item)
			{
				item.key = key;
				item.data = data;
			});
		}
	}

private:

	// @abi table records11e i64
	struct RecordStruct
	{
		uint64_t key;
		std::string data;
		uint64_t primary_key() const {return key;}
		EOSLIB_SERIALIZE(RecordStruct, (key)(data))
	};

	typedef multi_index<N(records11e), RecordStruct> RecordsTable;

	RecordsTable records11e;
};

EOSIO_ABI(w12eosbook, (setrecord))

//private:
//
//// @abi table records11e i64
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
//Records records11e;
//};

//void setrecord(account_name user, const uint64_t key, const uint64_t basekey, const uint64_t len, const std::string& data)
//{
//	auto base_it = records12j.find(basekey);
//	auto it = records12j.find(key);
//
//	if(base_it == records12j.end() && key == basekey)
//	{
//		records12j.emplace(user, [&](auto &item)
//		{
//			item.key = key;
//			item.len = 0;
//			item.data = data;
//		});
//	}
//	if(base_it != records12j.end() && base_it == records12j.end())
//	{
//		records12j.emplace(user, [&](auto &item)
//		{
//			item.key = key;
//			item.len = 0;
//			item.data = data;
//		});
//	}
//
//}
//
//private:
//
//// @abi table records12j i64
//struct RecordStruct
//{
//	uint64_t key;
//	uint64_t len;
//	std::string data;
//
//	uint64_t primary_key() const {return key;}
//	EOSLIB_SERIALIZE(RecordStruct, (key)(len)(data))
//};
//
//typedef multi_index<N(records12j), RecordStruct> Records;
//
//Records records12j;
//
//};
//
//EOSIO_ABI(w12eosbook, (setrecord))



