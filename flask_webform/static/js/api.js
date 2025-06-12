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
        default_display: defaultDisplay
    };

    // 🔹 Add GZI Location only if BgzipFastaAdapter is selected
    if (fastaType === "BgzipFastaAdapter") {
        payload.sequence.adapter.gziLocation = { uri: getFieldValue("gziLocation") };
    }

    console.log(" Sending Assembly Data:", payload);

    try {
        // 🔹 Send data to Flask API
        const response = await fetch('/insert_assembly', {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify(payload)
        });

        const result = await response.json();
        console.log(" Response:", result);

        // 🔹 Show success or error message
        if (result.success) {
            alert(`Assembly ${payload.name} inserted successfully!`);
        } else {
            alert(`Error: ${result.error}`);
        }
    } catch (error) {
        console.error(" Error submitting assembly:", error);
        alert("Failed to insert assembly. Check console for details.");
    }
}

async function submitVCFForm(event) {
    event.preventDefault(); // Prevent form reload

    // 🔹 Determine which field definitions to use
    const trackType = "VCF";
    const fieldData = fieldDefinitions[trackType] ? fieldDefinitions[trackType].fields : [];

    // 🔹 Helper function to get field value by ID
    function getFieldValue(fieldId, defaultValue = "") {
        const field = document.getElementById(fieldId);
        return field ? field.value.trim() : defaultValue;
    }

    // 🔹 Get selected displays
    const { selectedDisplays, defaultDisplay } = getSelectedDisplays();

    // 🔹 Get selected categories
    const selectedCategories = getSelectedCategories(); // Use function to get proper categories

    // 🔹 Construct payload using dynamic field values
    const payload = {
        trackId: getFieldValue("trackId"),
        type: getFieldValue("type"),
        name: getFieldValue("name"),
        assemblyNames: getFieldValue("assemblyNames").split(",").map(a => a.trim()).filter(Boolean),
        category: selectedCategories,
        adapter: {
            type: getFieldValue("adapterType"),
            vcfGzLocation: { uri: getFieldValue("vcfGzLocation") },
            indexLocation: { uri: getFieldValue("indexLocation") }
        },
        displays: selectedDisplays,
        default_display: defaultDisplay
    };

    console.log(" Default Display Being Sent:", defaultDisplay);


    try {
        // 🔹 Send data to Flask API
        const response = await fetch('/insert_vcf', {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify(payload)
        });

        const result = await response.json();
        console.log("Response:", result);

        // 🔹 Show success or error message
        if (result.success) {
            alert(`VCF Track ${payload.name} inserted successfully!`);
        } else {
            alert(`Error: ${result.error}`);
        }
    } catch (error) {
        console.error("Error submitting VCF track:", error);
        alert("Failed to insert VCF track. Check console for details.");
    }
}


async function submitBAMForm(event) {
    event.preventDefault(); // Prevent form reload

    // 🔹 Helper function to get field value by ID
    function getFieldValue(fieldId, defaultValue = "") {
        const field = document.getElementById(fieldId);
        return field ? field.value.trim() : defaultValue;
    }

    // 🔹 Get selected assembly name
    const assemblyNames = getFieldValue("assemblyNames").split(",").map(a => a.trim()).filter(Boolean);
    if (assemblyNames.length === 0) {
        alert("Error: No assembly selected.");
        return;
    }
    const assemblyName = assemblyNames[0]; // Take first assembly (assuming one is selected)

    try {
        // 🔹 Fetch sequence adapter ID and type for the selected assembly
        const response = await fetch(`/get_sequence_adapter_id?assembly=${assemblyName}`);
        const adapterData = await response.json();

        if (!adapterData.sequenceAdapterId) {
            alert(`Error: No sequence adapter found for assembly ${assemblyName}`);
            return;
        }

        // 🔹 Get selected displays
        const { selectedDisplays, defaultDisplay } = getSelectedDisplays();

        // 🔹 Construct payload
        const payload = {
            trackId: getFieldValue("trackId"),
            type: getFieldValue("type"),
            name: getFieldValue("name"),
            assemblyNames: assemblyNames,
            category: getSelectedCategories(), // Use getSelectedCategories()
            adapter: {
                type: getFieldValue("adapterType"),
                bamLocation: { uri: getFieldValue("bamLocation") },
                indexLocation: { uri: getFieldValue("indexLocation") },
                sequenceAdapterId: adapterData.sequenceAdapterId, // Retrieved from DB
                sequenceAdapterType: adapterData.sequenceAdapterType // Retrieved from DB
            },
            displays: selectedDisplays,
            default_display: defaultDisplay
        };

        console.log(" Sending BAM Track Data:", payload);

        // 🔹 Send data to Flask API
        const insertResponse = await fetch('/insert_bam', {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify(payload)
        });

        const result = await insertResponse.json();
        console.log(" Response:", result);

        // 🔹 Show success or error message
        if (result.success) {
            alert(`BAM Track ${payload.name} inserted successfully!`);
        } else {
            alert(`Error: ${result.error}`);
        }
    } catch (error) {
        console.error(" Error submitting BAM track:", error);
        alert("Failed to insert BAM track. Check console for details.");
    }
}

async function submitCRAMForm(event) {
    event.preventDefault(); // Prevent form reload

    // 🔹 Determine which field definitions to use
    const trackType = "CRAM";
    const fieldData = fieldDefinitions[trackType] ? fieldDefinitions[trackType].fields : [];

    // 🔹 Helper function to get field value by ID
    function getFieldValue(fieldId, defaultValue = "") {
        const field = document.getElementById(fieldId);
        return field ? field.value.trim() : defaultValue;
    }

    // 🔹 Get selected displays
    const { selectedDisplays, defaultDisplay } = getSelectedDisplays();

    // 🔹 Get sequence adapter ID & type
    const assemblyName = getFieldValue("assemblyNames");
    let sequenceAdapterId = "";
    let sequenceAdapterType = "";

    try {
        const adapterResponse = await fetch(`/get_sequence_adapter_id?assembly=${encodeURIComponent(assemblyName)}`);
        const adapterData = await adapterResponse.json();
        if (adapterData.sequenceAdapterId) {
            sequenceAdapterId = adapterData.sequenceAdapterId;
            sequenceAdapterType = adapterData.sequenceAdapterType;
        } else {
            console.error("Error fetching sequence adapter:", adapterData.error);
            alert("Failed to find a sequence adapter for the selected assembly.");
            return;
        }
    } catch (error) {
        console.error("Error fetching sequence adapter:", error);
        alert("Failed to fetch sequence adapter data.");
        return;
    }

    // 🔹 Construct payload using dynamic field values
    const payload = {
        trackId: getFieldValue("trackId"),
        type: getFieldValue("type"),
        name: getFieldValue("name"),
        assemblyNames: getFieldValue("assemblyNames").split(",").map(a => a.trim()).filter(Boolean),
        category: getSelectedCategories(), // Use the getSelectedCategories() function
        adapter: {
            type: getFieldValue("adapterType"),
            cramLocation: { uri: getFieldValue("cramLocation") },
            craiLocation: { uri: getFieldValue("craiLocation") },
            sequenceAdapterId: sequenceAdapterId,
            sequenceAdapterType: sequenceAdapterType
        },
        displays: selectedDisplays,
        default_display: defaultDisplay
    };

    console.log("Sending CRAM Track Data:", payload);

    try {
        // 🔹 Send data to Flask API
        const response = await fetch('/insert_cram', {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify(payload)
        });

        const result = await response.json();
        console.log("Response:", result);

        // 🔹 Show success or error message
        if (result.success) {
            alert(`CRAM Track ${payload.name} inserted successfully!`);
        } else {
            alert(`Error: ${result.error}`);
        }
    } catch (error) {
        console.error("Error submitting CRAM track:", error);
        alert("Failed to insert CRAM track. Check console for details.");
    }
}


async function submitBEDForm(event) {
    event.preventDefault(); // Prevent form reload

    // 🔹 Determine which field definitions to use
    const trackType = "BED";
    const fieldData = fieldDefinitions[trackType] ? fieldDefinitions[trackType].fields : [];

    // 🔹 Helper function to get field value by ID
    function getFieldValue(fieldId, defaultValue = "") {
        const field = document.getElementById(fieldId);
        return field ? field.value.trim() : defaultValue;
    }

    // 🔹 Get selected displays
    const { selectedDisplays, defaultDisplay } = getSelectedDisplays();

    // 🔹 Construct payload using dynamic field values
    const payload = {
        trackId: getFieldValue("trackId"),
        type: getFieldValue("type"),
        name: getFieldValue("name"),
        assemblyNames: getFieldValue("assemblyNames").split(",").map(a => a.trim()).filter(Boolean),
        category: getSelectedCategories(), //Use getSelectedCategories() function
        adapter: {
            type: getFieldValue("adapterType"),
            bedGzLocation: { uri: getFieldValue("bedGzLocation") },
            indexLocation: { uri: getFieldValue("indexLocation") }
        },
        displays: selectedDisplays,
        default_display: defaultDisplay
    };

    console.log("Sending BED Track Data:", payload);

    try {
        // 🔹 Send data to Flask API
        const response = await fetch('/insert_bed', {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify(payload)
        });

        const result = await response.json();
        console.log("Response:", result);

        // 🔹 Show success or error message
        if (result.success) {
            alert(`BED Track ${payload.name} inserted successfully!`);
        } else {
            alert(`Error: ${result.error}`);
        }
    } catch (error) {
        console.error("Error submitting BED track:", error);
        alert("Failed to insert BED track. Check console for details.");
    }
}


async function submitPAFForm(event) {
    event.preventDefault(); // Prevent form reload

    const assemblyNames = Array.from(document.querySelectorAll("input[name='assemblyNames']:checked"))
    .map(checkbox => checkbox.value)
    .filter(Boolean);


    // Enforce minimum of 2 assemblies for PAF
    if (assemblyNames.length < 2) {
        document.getElementById("assembly_error").style.display = "block"; // Show error
        alert("Please select at least two assemblies for a PAF track.");
        return;
    } else {
        document.getElementById("assembly_error").style.display = "none"; // Hide error
    }

    // 🔹 Determine which field definitions to use
    const trackType = "PAF";
    const fieldData = fieldDefinitions[trackType] ? fieldDefinitions[trackType].fields : [];

    // 🔹 Helper function to get field value by ID
    function getFieldValue(fieldId, defaultValue = "") {
        const field = document.getElementById(fieldId);
        return field ? field.value.trim() : defaultValue;
    }

    // 🔹 Get selected displays
    const { selectedDisplays } = getSelectedDisplays();

    // 🔹 Construct payload using dynamic field values
    const payload = {
        trackId: getFieldValue("trackId"),
        type: getFieldValue("type"),
        name: getFieldValue("name"),
        assemblyNames: assemblyNames,
        category: getSelectedCategories(), // Use the getSelectedCategories() function
        adapter: {
            type: getFieldValue("adapterType"),
            pafLocation: { uri: getFieldValue("pafLocation") }
        },
        displays: selectedDisplays
    };

    console.log("Sending PAF Track Data:", payload);

    try {
        // 🔹 Send data to Flask API
        const response = await fetch('/insert_paf', {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify(payload)
        });

        const result = await response.json();
        console.log("Response:", result);

        // 🔹 Show success or error message
        if (result.success) {
            alert(`PAF Track ${payload.name} inserted successfully!`);
        } else {
            alert(`Error: ${result.error}`);
        }
    } catch (error) {
        console.error("Error submitting PAF track:", error);
        alert("Failed to insert PAF track. Check console for details.");
    }
}


async function submitDELTAForm(event) {
    event.preventDefault();

    const assemblyNames = Array.from(document.querySelectorAll("input[name='assemblyNames']:checked"))
        .map(cb => cb.value)
        .filter(Boolean);

    if (assemblyNames.length < 2) {
        alert("Please select at least two assemblies for a DELTA track.");
        return;
    }

    function getFieldValue(fieldId, defaultValue = "") {
        const field = document.getElementById(fieldId);
        return field ? field.value.trim() : defaultValue;
    }

    const { selectedDisplays } = getSelectedDisplays();

    const defaultDisplay = document.querySelector('input[name="default_display"]:checked')?.value;

    const payload = {
        trackId: getFieldValue("trackId"),
        type: getFieldValue("type"),
        name: getFieldValue("name"),
        assemblyNames: assemblyNames,
        category: getSelectedCategories(),
        adapter: {
            type: getFieldValue("adapterType"),
            deltaLocation: { uri: getFieldValue("deltaLocation") }
        },
        displays: selectedDisplays,
        default_display: defaultDisplay
    };

    console.log("Sending DELTA Track Data:", payload);

    try {
        const response = await fetch('/insert_delta', {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify(payload)
        });

        const result = await response.json();
        console.log("Response:", result);

        if (result.success) {
            alert(`DELTA Track ${payload.name} inserted successfully!`);
        } else {
            alert(`Error: ${result.error}`);
        }
    } catch (error) {
        console.error("Error submitting DELTA track:", error);
        alert("Failed to insert DELTA track. Check console for details.");
    }
}


async function submitGFFForm(event) {
    event.preventDefault(); // Prevent form reload

    function getFieldValue(fieldId, defaultValue = "") {
        const field = document.getElementById(fieldId);
        return field ? field.value.trim() : defaultValue;
    }

    const assemblyNames = getFieldValue("assemblyNames")
        .split(",")
        .map(a => a.trim())
        .filter(Boolean);

    const { selectedDisplays, defaultDisplay } = getSelectedDisplays();


    const payload = {
        trackId: getFieldValue("trackId"),
        type: getFieldValue("type"),
        name: getFieldValue("name"),
        assemblyNames: assemblyNames,
        category: getSelectedCategories(),
        adapter: {
            type: getFieldValue("adapterType"),
            gffGzLocation: { uri: getFieldValue("gffGzLocation") },
            indexLocation: { uri: getFieldValue("indexLocation") }
        },
        displays: selectedDisplays,
        default_display: defaultDisplay
    };

    console.log("Sending GFF Track Data:", payload);

    try {
        const response = await fetch('/insert_gff', {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify(payload)
        });

        const result = await response.json();
        console.log("Response:", result);

        if (result.success) {
            alert(`GFF Track ${payload.name} inserted successfully!`);
        } else {
            alert(`Error: ${result.error}`);
        }
    } catch (error) {
        console.error("Error submitting GFF track:", error);
        alert("Failed to insert GFF track. Check console for details.");
    }
}

async function submitBatchBAMs() {
    const rawPaths = document.getElementById("batch_file_paths").value;
    const rawNames = document.getElementById("batch_track_names").value;

    const allPaths = rawPaths.split(/[\n,]+/).map(s => s.trim()).filter(Boolean);
    const allNames = rawNames.split(/[\n,]+/).map(s => s.trim()).filter(Boolean);

    const assemblyDropdown = document.getElementById("assemblyNames");
    const assemblyName = assemblyDropdown?.value;

    if (!assemblyName) {
        alert("Error: No assembly selected.");
        return;
    }

    // Fetch sequence adapter once
    let adapterData;
    try {
        const response = await fetch(`/get_sequence_adapter_id?assembly=${assemblyName}`);
        adapterData = await response.json();

        if (!adapterData.sequenceAdapterId) {
            alert(`Error: No sequence adapter found for assembly ${assemblyName}`);
            return;
        }
    } catch (error) {
        console.error("Failed to get sequence adapter:", error);
        alert("Could not fetch sequence adapter info.");
        return;
    }

    // 🔹 Get selected displays and category
    const { selectedDisplays, defaultDisplay } = getSelectedDisplays();
    const category = getSelectedBatchCategories()


    for (let i = 0; i < allPaths.length; i++) {
        const path = allPaths[i];
        const name = allNames[i];
        const timestamp = Date.now();
        const trackId = `${name.replace(/\s+/g, "_")}-${timestamp}`;

        const payload = {
            trackId: trackId,
            type: "AlignmentsTrack",
            name: name,
            assemblyNames: [assemblyName],
            category: category,
            adapter: {
                type: "BamAdapter",
                bamLocation: { uri: path },
                indexLocation: { uri: `${path}.bai` },
                sequenceAdapterId: adapterData.sequenceAdapterId,
                sequenceAdapterType: adapterData.sequenceAdapterType
            },
            displays: selectedDisplays,
            default_display: defaultDisplay
        };

        console.log(`Submitting track ${i + 1}/${allPaths.length}:`, payload);

        try {
            const insertResponse = await fetch('/insert_bam', {
                method: 'POST',
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify(payload)
            });

            const result = await insertResponse.json();
            console.log(`Track ${name}:`, result);

            if (!result.success) {
                alert(`Insert failed for ${name}: ${result.error}`);
            }
        } catch (err) {
            console.error(`Error inserting ${name}:`, err);
            alert(`Error inserting ${name}. See console.`);
        }
    }

    alert("Batch insert completed.");
}


function getSelectedCategories() {
    const box = document.querySelector(".category-node input[type='checkbox']:checked");
    if (!box) return [];
    const path = box.dataset.fullPath;
    return path ? path.split("/") : [];
}

function getSelectedBatchCategories() {
    const container = document.getElementById("batch_dynamic_fields");
    if (!container) return [];

    const box = container.querySelector("input[type='checkbox'][data-full-path]:checked");
    if (!box) return [];

    const path = box.dataset.fullPath;
    return path ? path.split("/") : [];
}

function getSelectedDisplays() {
    const selectedDisplays = [];
    document.querySelectorAll("input[name='display']:checked").forEach(checkbox => {
        selectedDisplays.push({
            type: checkbox.value,
            displayId: `${document.getElementById("name")?.value || "unknown"}-${checkbox.value}`
        });
    });

    //Ensure there's a default display selected before accessing its value
    const defaultDisplayInput = document.querySelector("input[name='default_display']:checked");
    const defaultDisplay = defaultDisplayInput ? defaultDisplayInput.value : null;

    //Validate: At least one display must be selected
    if (selectedDisplays.length === 0) {
        alert("Please select at least one display type.");
        throw new Error("No display selected.");
    }

    //Validate: Default must be among the selected displays
    const defaultInSelected = selectedDisplays.some(d => d.type === defaultDisplay);
    if (!defaultInSelected) {
        alert("The selected default display must be one of the checked display options.");
        throw new Error("Default display not in selected displays.");
    }

    return { selectedDisplays, defaultDisplay };
}


function handleFormSubmission(event) {
    const isAssembly = document.getElementById("assembly").checked;
    const fileLocation = document.getElementById("file_location").value.trim();

    const fileParts = fileLocation.toLowerCase().split('.');
    let fileExtension = fileParts.pop();
    if (fileExtension === "gz" && fileParts.length > 0) {
        fileExtension = fileParts.pop();
    }

    const feedback = document.getElementById("file_location_feedback").textContent;
    if (feedback !== "✅") {
        alert("Please provide a valid file location before submitting.");
        return;
    }

    const selectedTrackType = isAssembly
        ? (assemblyFileTypes[fileExtension] || "")
        : (trackFileTypes[fileExtension] || "");

    if (isAssembly) {
        submitAssemblyForm(event);
    } else {
        switch (selectedTrackType) {
            case "VCF":
                submitVCFForm(event); break;
            case "BAM":
                submitBAMForm(event); break;
            case "CRAM":
                submitCRAMForm(event); break;
            case "GFF":
                submitGFFForm(event); break;
            case "BED":
                submitBEDForm(event); break;
            case "PAF":
                submitPAFForm(event); break;
            case "DELTA":
                submitDELTAForm(event); break;
            default:
                alert("Unsupported or unrecognized track type.");
                console.error(`No handler for track type: ${selectedTrackType}`);
                break;
        }
    }
}




