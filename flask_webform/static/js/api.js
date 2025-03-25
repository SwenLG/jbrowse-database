async function submitAssemblyForm(event) {
    event.preventDefault(); // Prevent form from reloading the page

    // 🔹 Get selected fasta type
    const fastaType = document.querySelector("input[name='fasta_type']:checked").value;
    
    // 🔹 Determine which field definitions to use
    const fieldData = fieldDefinitions[fastaType] ? fieldDefinitions[fastaType].fields : [];

    // 🔹 Helper function to get field value by ID
    function getFieldValue(fieldId, defaultValue = "") {
        const field = document.getElementById(fieldId);
        return field ? field.value.trim() : defaultValue;
    }

    // 🔹 Get selected displays
    const { selectedDisplays, defaultDisplay } = getSelectedDisplays();

    // 🔹 Construct payload using dynamic field values
    const payload = {
        name: getFieldValue("name"),  // Get Assembly Name from dynamic field
        displayName: getFieldValue("displayName"),
        aliases: getFieldValue("aliases").split(",").map(a => a.trim()).filter(Boolean),
        sequence: {
            trackId: getFieldValue("sequence_trackId"),
            type: getFieldValue("sequence_type"),
            adapter: {
                type: fastaType,
                fastaLocation: { uri: getFieldValue("fastaLocation") },
                faiLocation: { uri: getFieldValue("faiLocation") },
                metadataLocation: { uri: getFieldValue("metadataLocation") }
            }
        },
        displays: selectedDisplays,  // 🔹 Include selected displays
    };

    // 🔹 Add GZI Location only if BgzipFastaAdapter is selected
    if (fastaType === "BgzipFastaAdapter") {
        payload.sequence.adapter.gziLocation = { uri: getFieldValue("gziLocation") };
    }

    console.log("📤 Sending Assembly Data:", payload);

    try {
        // 🔹 Send data to Flask API
        const response = await fetch('/insert_assembly', {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify(payload)
        });

        const result = await response.json();
        console.log("✅ Response:", result);

        // 🔹 Show success or error message
        if (result.success) {
            alert(`Assembly ${payload.name} inserted successfully!`);
        } else {
            alert(`Error: ${result.error}`);
        }
    } catch (error) {
        console.error("❌ Error submitting assembly:", error);
        alert("Failed to insert assembly. Check console for details.");
    }
}

function getSelectedDisplays() {
    const selectedDisplays = [];
    document.querySelectorAll("input[name='display']:checked").forEach(checkbox => {
        selectedDisplays.push({
            type: checkbox.value,
            displayId: `${document.getElementById("name").value}-${checkbox.value}`
        });
    });

    const defaultDisplay = document.querySelector("input[name='default_display']:checked").value;

    // ✅ Move the default display to the front of the list
    if (defaultDisplay) {
        selectedDisplays.sort((a, b) => (a.displayId === `${document.getElementById("name").value}-${defaultDisplay}` ? -1 : 1));
    }

    return { selectedDisplays };
}


