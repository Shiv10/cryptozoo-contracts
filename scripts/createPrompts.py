import json

elements = ['Fire','water', 'earth', 'Air']
personas = ['Honesty', 'Cunning', 'Hardworking', 'Inspiring']
traits = ['Bravery', 'Ambition', 'Empathy']

names = open("names.txt", "r")
for i in range(0, len(elements)):
    for j in range(0, len(personas)):
        for k in range (0, len(traits)):
            obj = {
                "name": names.readline().strip(),
                "description": "NFT by cryptkiddies",
                "image": "https://ipfs.io/ipfs/",
                "attributes": [
                    {
                        "trait_type": "Aura",
                        "value": elements[i]
                    },
                    {
                        "trait_type": "Persona",
                        "value": personas[j]
                    },
                    {
                        "trait_type": "Trait",
                        "value": traits[k]
                    }
                ]
            }

            with open("metadata/"+str(i+1)+str(j+1)+str(k+1)+".json", "w") as outfile:
                json.dump(obj, outfile)

