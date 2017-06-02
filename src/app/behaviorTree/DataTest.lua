return {
  ["id"] = "37512958-61aa-4e55-883c-64af11a39310",
  ["title"] = "A behavior tree",
  ["description"] = "",
  ["root"] = "9a3be3da-912e-482d-8c88-0a8fd6a772be",
  ["properties"] = {},
  ["nodes"] = {
    ["9a3be3da-912e-482d-8c88-0a8fd6a772be"] = {
      ["id"] = "9a3be3da-912e-482d-8c88-0a8fd6a772be",
      ["name"] = "Sequence",
      ["title"] = "Sequence",
      ["description"] = "",
      ["properties"] = {},
      ["children"] = {
        "b2c97259-9735-4bb7-8667-90126ab208e1",
        "3c3afda0-8c82-46d6-acca-8ceef103aaf4"
      }
    },
    ["b2c97259-9735-4bb7-8667-90126ab208e1"] = {
      ["id"] = "b2c97259-9735-4bb7-8667-90126ab208e1",
      ["name"] = "Selector",
      ["title"] = "Selector",
      ["description"] = "",
      ["properties"] = {},
      ["children"] = {
        "6bb80d1f-94bb-4d7f-8bc6-af482ee75023",
        "f6f70830-534d-4f3a-8888-9a3494c36ce3"
      }
    },
    ["6bb80d1f-94bb-4d7f-8bc6-af482ee75023"] = {
      ["id"] = "6bb80d1f-94bb-4d7f-8bc6-af482ee75023",
      ["name"] = "Inverter",
      ["title"] = "Inverter",
      ["description"] = "",
      ["properties"] = {},
      ["child"] = "de14337d-bcf3-4ac7-8b4a-718ff06b425d"
    },
    ["de14337d-bcf3-4ac7-8b4a-718ff06b425d"] = {
      ["id"] = "de14337d-bcf3-4ac7-8b4a-718ff06b425d",
      ["name"] = "isHaveEnemy",
      ["title"] = "isHaveEnemy",
      ["description"] = "",
      ["properties"] = {},
    },
    ["f6f70830-534d-4f3a-8888-9a3494c36ce3"] = {
      ["id"] = "f6f70830-534d-4f3a-8888-9a3494c36ce3",
      ["name"] = "Parrallel Selector",
      ["title"] = "Parrallel Selector",
      ["description"] = "",
      ["properties"] = {},
      ["children"] = {
        "76c668f5-b382-46a6-8942-44ff39046ca6",
        "97722873-247e-4146-8d96-8c6c3590b09f"
      }
    },
    ["76c668f5-b382-46a6-8942-44ff39046ca6"] = {
      ["id"] = "76c668f5-b382-46a6-8942-44ff39046ca6",
      ["name"] = "isHaveEnemy",
      ["title"] = "isHaveEnemy",
      ["description"] = "",
      ["properties"] = {},
    },
    ["97722873-247e-4146-8d96-8c6c3590b09f"] = {
      ["id"] = "97722873-247e-4146-8d96-8c6c3590b09f",
      ["name"] = "Attack",
      ["title"] = "Attack",
      ["description"] = "",
      ["properties"] = {},
    },
    ["3c3afda0-8c82-46d6-acca-8ceef103aaf4"] = {
      ["id"] = "3c3afda0-8c82-46d6-acca-8ceef103aaf4",
      ["name"] = "Idle",
      ["title"] = "Idle",
      ["description"] = "",
      ["properties"] = {},
    }
  },
  ["custom_nodes"] = {
    {
      ["name"] = "Selector",
      ["category"] = "composite",
      ["title"] = "null",
      ["description"] = "null",
      ["properties"] = {}
    },
    {
      ["name"] = "isHaveEnemy",
      ["category"] = "condition",
      ["title"] = "null",
      ["description"] = "null",
      ["properties"] = {}
    },
    {
      ["name"] = "Parrallel Selector",
      ["category"] = "composite",
      ["title"] = "null",
      ["description"] = "null",
      ["properties"] = {}
    },
    {
      ["name"] = "Parrallel Sequence",
      ["category"] = "composite",
      ["title"] = "null",
      ["description"] = "null",
      ["properties"] = {}
    },
    {
      ["name"] = "Attack",
      ["category"] = "action",
      ["title"] = "null",
      ["description"] = "null",
      ["properties"] = {}
    },
    {
      ["name"] = "Idle",
      ["category"] = "action",
      ["title"] = "null",
      ["description"] = "null",
      ["properties"] = {}
    }
  }
}