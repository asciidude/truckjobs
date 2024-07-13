function formatNumber(number) {
    return new Intl.NumberFormat('en-US').format(number);
}

window.addEventListener('DOMContentLoaded', () => {
    console.log('DOM content for TruckJobs fully loaded');

    const truckList = document.getElementById('truckList');
    const truckModal = document.getElementById('truckModal');
    const truckClose = document.getElementById('truckClose');
    
    const jobList = document.getElementById('jobList');
    const jobModal = document.getElementById('jobModal');
    const jobBack = document.getElementById('jobBack');

    let currentTruck;

    // Fetch trucks
    fetch(`https://${GetParentResourceName()}/loadTrucks`, {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json',
        },
        body: JSON.stringify({}),
    });

    // Handle incoming truck list
    window.addEventListener('message', (event) => {
        if (event.data.type === 'trucksLoaded') {
            truckList.innerHTML = '';
            event.data.trucks.forEach(truck => {
                const listItem = document.createElement('li');
                listItem.classList.add('input-group');

                const truckName = document.createElement('p');
                truckName.textContent = truck.truckName;

                const selectButton = document.createElement('button');
                selectButton.textContent = 'Select';
                selectButton.addEventListener('click', () => {
                    currentTruck = truck;

                    fetch(`https://${GetParentResourceName()}/loadJobs`, {
                        method: 'POST',
                        headers: {
                            'Content-Type': 'application/json',
                        },
                        body: JSON.stringify({
                            truck: truck
                        }),
                    });

                    truckModal.classList.add('hidden');
                    jobModal.classList.remove('hidden');
                });

                listItem.appendChild(truckName);
                listItem.appendChild(selectButton);
                truckList.appendChild(listItem);
            });
        }
    });

    // Handle truck close button being pressed
    truckClose.addEventListener('mouseup', (event) => {
        document.body.style.background = 'transparent';

        jobModal.classList.add('hidden');
        truckModal.classList.add('hidden');

        fetch(`https://${GetParentResourceName()}/closeTruckMenu`, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json; charset=UTF-8'
            }
        });
    });

    // Handle incoming job list
    window.addEventListener('message', (event) => {
        if (event.data.type === 'jobsLoaded') {
            jobList.innerHTML = '';
            event.data.jobs.forEach(job => {
                const listItem = document.createElement('li');
                listItem.classList.add('input-group');

                const jobName = document.createElement('p');
                jobName.textContent = `${job.location} | ${job.cargo} | ${event.data.currency}${formatNumber(job.payout)}`;

                const selectButton = document.createElement('button');
                selectButton.textContent = 'Select';
                selectButton.addEventListener('click', () => {
                    document.body.style.background = 'transparent';
        
                    jobModal.classList.add('hidden');
                    truckModal.classList.add('hidden');

                    fetch(`https://${GetParentResourceName()}/selectJob`, {
                        method: 'POST',
                        headers: {
                            'Content-Type': 'application/json',
                        },
                        body: JSON.stringify({
                            job: job,
                            truck: currentTruck
                        }),
                    });
                });

                listItem.appendChild(jobName);
                listItem.appendChild(selectButton);
                jobList.appendChild(listItem);
            });
        }
    });

    // Handle job back button being pressed
    jobBack.addEventListener('mouseup', () => {
        jobModal.classList.add('hidden');
        truckModal.classList.remove('hidden');
    });

    // Open / close this menu
    window.addEventListener('message', (event) => {
        if (event.data.type === 'openTruckMenu') {
            jobModal.classList.add('hidden');
            truckModal.classList.remove('hidden');

            document.body.style.background = 'rgba(0, 0, 0, 0.5)';
        }
    });

    window.addEventListener('message', (event) => {
        if (event.data.type === 'closeTruckMenu') {
            document.body.style.background = 'transparent';

            jobModal.classList.add('hidden');
            truckModal.classList.add('hidden');

            fetch(`https://${GetParentResourceName()}/closeTruckMenu`, {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json; charset=UTF-8'
                }
            });
        }
    });
    
    document.addEventListener('keydown', (event) => {
        if (event.key === 'Escape') {
            document.body.style.background = 'transparent';

            jobModal.classList.add('hidden');
            truckModal.classList.add('hidden');

            fetch(`https://${GetParentResourceName()}/closeTruckMenu`, {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json; charset=UTF-8'
                }
            });
        }
    });
});