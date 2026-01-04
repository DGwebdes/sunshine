import { useParams } from "react-router-dom";
import mockup from "../utils/data.json";

const ServiceDetails = () => {
    const { serviceId } = useParams();
    const service = mockup.services[serviceId];

    if (!service) {
        return <div>Service not Found!</div>;
    }

    return (
        <div className="h-screen p-6 overflow-scroll md:overflow-hidden">
            <h1 className="text-3xl font-bold"> {service.name} </h1>
            <img
                src={service.image}
                alt={service.name}
                className="w-full h-64 object-cover rounded-md my-4"
            />
            <p className="text-lg"> {service.description} </p>
            <h3 className="text-xl mt-4">Categories:</h3>
            <ul className="flex flex-col">
                {service.categories.map((category) => (
                    <li
                        key={category.id}
                        className="mt-2 md:flex justify-between items-center p-3 bg-white shadow-md rounded-lg transform transition-all duration-200 hover:bg-amber-50"
                    >
                        <div className="flex-1 text-lg font-semibold text-gray-700">
                            {category.name}
                        </div>
                        <div className="flex-1 text-lg text-gray-600">
                            ${category.price}
                        </div>
                        <div className="flex-1 text-lg text-gray-600">
                            {category.duration}
                        </div>
                        <button className="ml-2 px-4 py-2 bg-amber-500 text-white rounded-md hover:bg-amber-600 transition">
                            Book Now
                        </button>
                    </li>
                ))}
            </ul>
        </div>
    );
};

export default ServiceDetails;
