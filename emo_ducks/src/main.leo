program emo_ducks.aleo {

    mapping duck_owners: field => address;

    record DuckNFT {
        owner: address,
        duck_id: field,
    }

    async transition mint_duck(public duck_id: field) -> (DuckNFT, Future) {
        let new_duck: DuckNFT = DuckNFT {
            owner: self.caller,
            duck_id,
        };

        // Return the new duck and a future that finalizes the mint.
        return (new_duck, finalize_mint(duck_id, self.caller));
    }

    // The finalize_mint async function will do the mapping operations:
    // - Read current owner from mapping
    // - Check if the duck is unowned
    // - Set the new owner
    async function finalize_mint(duck_id: field, new_owner: address) {
        let zero_owner: address = aleo1qqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqq3ljyzc;

        // Now we can safely use Mapping::get_or_use here.
        let current_owner: address = Mapping::get_or_use(duck_owners, duck_id, zero_owner);

        // Ensure this duck is not already owned.
        assert_eq(current_owner, zero_owner);

        // Assign the duck to the caller.
        Mapping::set(duck_owners, duck_id, new_owner);
    }
    

}

