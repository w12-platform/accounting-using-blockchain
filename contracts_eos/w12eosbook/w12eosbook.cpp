#include <eosio/eosio.hpp>


using namespace eosio;
using std::string;


class [[eosio::contract]] w12eosbook : public eosio::contract
{

public:


  w12eosbook( eosio::name receiver, eosio::name code, eosio::datastream<const char*> ds ): eosio::contract(receiver, code, ds),  records11i(receiver, code.value)
  {}

  // @abi action
  [[eosio::action]] void setrecord(name user, const uint64_t key, const std::string& data)
  {
    auto it = records11i.find(key);

    if(it == records11i.end())
    {

      records11i.emplace(user, [&](auto &item)
      {
        item.key = key;
        item.data = data;
      });
    }
  }

private:

  // @abi table records11i i64
  struct [[eosio::table]] record
  {
    uint64_t key;
    std::string data;
    uint64_t primary_key() const {return key;}

  };

  typedef multi_index<"record"_n, record> recordtable;

  recordtable records11i;
};

EOSIO_DISPATCH(w12eosbook, (setrecord))
